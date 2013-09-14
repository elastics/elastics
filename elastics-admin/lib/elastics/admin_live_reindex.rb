# ensure to load it before overriding it
require 'elastics/client_live_reindex'

module Elastics
  # private module
  module LiveReindex

    class MissingRedisError            < StandardError; end
    class LiveReindexInProgressError   < StandardError; end
    class MissingAppIdError            < StandardError; end
    class MissingStopIndexingProcError < StandardError; end
    class MissingEnsureIndicesError    < StandardError; end
    class MissingOnReindexBlockError   < StandardError; end
    class ExtraIndexError              < StandardError; end
    class MultipleReindexError         < StandardError; end

    # private module
    module Redis

      KEYS = { :pid     => 'elastics-reindexing-pid',
               :changes => 'elastics-reindexing-changes' }

      extend self

      def method_missing(command, key, *args)
        return unless Conf.redis
        Conf.redis.send(command, "#{KEYS[key]}-#{Conf.app_id}", *args)
      end

      def reset_keys
        KEYS.keys.each { |k| del k }
      end

      def init
        begin
          require 'redis'
        rescue LoadError
          raise MissingRedisError, 'The live-reindex feature rely on redis. Please, install redis and the "redis" gem.'
        end
        raise MissingAppIdError, 'You must set the Elastics::Configuration.app_id, and be sure you deploy it before live-reindexing.' \
              if Conf.app_id.nil? || Conf.app_id.empty?
        raise LiveReindexInProgressError, %(It looks like the live-reindex of "#{Conf.app_id}" is in progress (PID #{get(:pid)}). If you are sure that there is no live-reindex in progress, please run the "elastics:admin:reset_redis_keys APP_ID=#{Conf.app_id}" rake task and retry.) \
              if get(:pid)
        reset_keys # just in case
        set(:pid, $$)
      end

    end

    def on_reindex(&block)
      @reindex = block
    end

    def on_each_change(&block)
      @each_change = block
    end
    attr_reader :each_change

    def on_stop_indexing(&block)
      @stop_indexing = block
    end

    def reindex(opts={})
      yield self
      opts[:verbose] = true unless opts.has_key?(:verbose)
      perform(opts)
    end

    def reindex_indices(opts={})
      yield self if block_given?

      opts[:verbose] = true unless opts.has_key?(:verbose)
      opts[:index] ||= opts.delete(:indices) || config_hash.keys

      # we override the on_reindex eventually set
      on_reindex do
        migrate_indices(opts)
      end

      perform(opts)
    end

    def should_prefix_index?
      Redis.get(:pid) == $$.to_s
    end

    def should_track_change?
      pid = Redis.get(:pid)
      !!pid && !(pid == $$.to_s)
    end

    def track_change(action, document)
      Redis.rpush(:changes, MultiJson.encode([action, document]))
    end

    # use this method when you are tracking the change of another app
    # you must pass the app_id of the app being affected by the change
    def track_external_change(app_id, action, document)
      return unless Conf.redis
      Conf.redis.rpush("#{KEYS[:changes]}-#{app_id}", MultiJson.encode([action, document]))
    end

    def prefix_index(index)
      base = unprefix_index(index)
      # raise if base is not included in @ensure_indices
      raise ExtraIndexError, "The index #{base} is missing from the :ensure_indices option. Reindexing aborted." \
            if @ensure_indices && !@ensure_indices.include?(base)
      prefixed = @prefix + base
      unless @indices.include?(base)
        unless Elastics.exist?(:index => prefixed)
          config_hash[base] = {} unless config_hash.has_key?(base)
          Elastics.POST "/#{prefixed}", config_hash[base]
        end
        @indices |= [base]
      end
      prefixed
    end

    # remove the (eventual) prefix
    def unprefix_index(index)
      index.sub(/^\d{14}_/, '')
    end

    private

    def config_hash
      @config_hash ||= ModelTasks.new.config_hash
    end

    def perform(opts={})
      Prompter.say_title 'Live-Reindex' if opts[:verbose]
      if opts[:safe_reindex] == false
        Conf.logger.warn 'Safe reindex is disabled!'
        Prompter.say_warning 'WARNING: Safe reindex is disabled!' if opts[:verbose]
      end
      Redis.init
      @indices        = []
      @prefix         = Time.now.strftime('%Y%m%d%H%M%S_')
      @ensure_indices = nil

      unless opts[:on_stop_indexing] == false || Conf.on_stop_indexing == false
        @stop_indexing ||= Conf.on_stop_indexing || raise(MissingStopIndexingProcError, 'The on_stop_indexing block is not set.')
      end

      raise MissingOnReindexBlockError, 'You must configure an on_reindex block.' \
            unless @reindex

      raise MissingEnsureIndicesError, 'You must pass the :ensure_indices option when you pass the :models option.' \
            if opts.has_key?(:models) && !opts.has_key?(:ensure_indices)
      if opts[:ensure_indices]
        @ensure_indices = opts.delete(:ensure_indices)
        @ensure_indices = @ensure_indices.split(',') unless @ensure_indices.is_a?(Array)
        each_change     = @each_change
        @each_change    = nil
        migrate_indices(:index => @ensure_indices)
        @each_change    = each_change
      end

      @reindex.call

      # try to empty the changes for 10 times before stopping the indexing
      10.times{ index_changes(opts) }

      # at this point the changes list should be empty or contain the minimum number of changes we could achieve live
      # the @stop_indexing should ensure to stop/suspend all the actions that would produce changes in the indices being reindexed
      if @stop_indexing
        Prompter.say_notice 'Calling on_stop_indexing...' if opts[:verbose]
        @stop_indexing.call
        Prompter.say_notice 'Indexing stopped.' if opts[:verbose]
      else
        Prompter.say_notice 'No on_stop_indexing provided.' if opts[:verbose]
      end

      # if we have still changes, we can index them all, now that the indexing is stopped
      index_changes(opts)

      # deletes the old indices and create the aliases to the new
      @indices.each do |index|
        Elastics.delete_index :index => index,
                              :raise => false # may not exist
        Elastics.post_index_aliases :actions => [{ :add => { :alias => index,
                                                             :index => @prefix + index } }]
      end
      # after the execution of this method the user should deploy the new code and then resume the regular app processing

      # we redefine this method so it will raise an error if any new live-reindex is attempted during this session.
      unless opts[:safe_reindex] == false
        class_eval <<-ruby, __FILE__, __LINE__
          def perform(*)
            raise MultipleReindexError, "Multiple live-reindex attempted! You cannot use any reindexing method multiple times in the same session or you may corrupt your index/indices! The previous reindexing in this session successfully reindexed and swapped the new index/indices: #{@indices.map{|i| @prefix + i}.join(', ')}. You must deploy now, and run the other reindexing in single successive deploys ASAP. Notice that if the code-changes that you are about to deploy rely on the successive reindexings that have been aborted, your app may fail. If you are working in development mode you must restart the session now. The next time you can silence this error by passing :safe_reindex => false"
          end
        ruby
      end

    rescue Exception
      # delete all the created indices
      @indices ||=[]
      @indices.each do |index|
        Elastics.delete_index :index => @prefix + index
      end
      raise

    ensure
      Redis.reset_keys
    end

    def index_changes(opts)
      left_changes_count = Redis.llen(:changes) || 0
      return if left_changes_count == 0

      batch_size  = opts[:batch_size] || 100
      bulk_string = ''
      Prompter.say_notice "Reindexing #{left_changes_count} live-changes..." if opts[:verbose]

      until left_changes_count == 0
        batch_count = left_changes_count > batch_size ? batch_size : left_changes_count
        batch_count.times do
          bulk_string << build_bulk_string_from_change(Redis.lpop(:changes))
          left_changes_count -= 1
        end
        Elastics.post_bulk_string(:bulk_string => bulk_string)
        bulk_string = ''
      end
    end

    def migrate_indices(opts)
      Conf.http_client.options[:timeout] = opts[:timeout] || 60

      opts[:verbose] = true unless opts.has_key?(:verbose)
      pbar = ProgBar.new(Elastics.count(opts)['count'], nil, "index #{opts[:index].inspect}: ") if opts[:verbose]

      Elastics.dump_all(opts) do |batch|
        result = process_and_post_batch(batch)
        pbar.process_result(result, batch.size) if opts[:verbose]
      end

      pbar.finish if opts[:verbose]
    end

    def process_and_post_batch(batch)
      bulk_string = ''
      batch.each do |document|
        bulk_string << build_bulk_string('index', document)
      end
      Elastics.post_bulk_string(:bulk_string => bulk_string)
    end

    def build_bulk_string_from_change(change)
      action, document = MultiJson.decode(change)
      return '' unless @indices.include?(unprefix_index(document['_index']))
      build_bulk_string(action, document)
    end

    def build_bulk_string(action, document)
      result = if @each_change
                 document.extend(Result::Document)
                 document.extend(Result::DocumentLoader)
                 @each_change.call(action, document)
               else
                 [{ action => document }]
               end
      result = [result] unless result.is_a?(Array)
      bulk_string = ''
      result.compact.each do |hash|
        act, doc = hash.to_a.flatten
        bulk_string << Elastics.build_bulk_string(doc, :action => act)
      end
      bulk_string
    end

  end
end
