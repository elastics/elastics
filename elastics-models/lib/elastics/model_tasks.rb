require 'elastics/tasks'

module Elastics

  class Tasks
    # patches the Elastics::Tasks#config_hash so it evaluates also the default mapping for models
    # it modifies also the index:create task
    alias_method :original_config_hash, :config_hash
    def config_hash
      @config_hash ||= begin
                         default = {}.extend Struct::Mergeable
                         (Conf.elastics_models + Conf.elastics_active_models).each do |m|
                           m = eval"::#{m}" if m.is_a?(String)
                           default.deep_merge! m.elastics.default_mapping
                         end
                         default.deep_merge(original_config_hash)
                       end
    end
  end

  class ModelTasks < Elastics::Tasks

    attr_reader :options

    def initialize(overrides={})
      options = Elastics::Utils.env2options *default_options.keys

      options[:timeout]    = options[:timeout].to_i      if options[:timeout]
      options[:batch_size] = options[:batch_size].to_i   if options[:batch_size]
      options[:models]     = options[:models].split(',') if options[:models]

      if options[:import_options]
        import_options = {}
        options[:import_options].split('&').each do |pair|
          k, v  = pair.split('=')
          import_options[k.to_sym] = v
        end
        options[:import_options] = import_options
      end

      @options = default_options.merge(options).merge(overrides)
    end

    def default_options
      @default_options ||= { :force          => false,
                             :timeout        => 60,
                             :batch_size     => 500,
                             :import_options => { },
                             :models         => Conf.elastics_models,
                             :config_file    => Conf.config_file,
                             :verbose        => true }
    end

    def import_models
      Prompter.say_title "Import models: #{models.map(&:to_s).inspect}" if options[:verbose]
      Conf.http_client.options[:timeout] = options[:timeout]
      deleted = []
      models.each do |model|
        raise ArgumentError, "The model #{model.name} is not a standard Elastics::ModelIndexer model" \
              unless model.include?(Elastics::ModelIndexer)
        index = model.elastics.index
        index = LiveReindex.prefix_index(index) if LiveReindex.should_prefix_index?

        # block never called during live-reindex, since it doesn't exist
        if options[:force]
          unless deleted.include?(index)
            delete_index(index)
            deleted << index
            Prompter.say_warning "#{index} index deleted" if options[:verbose]
          end
        end

        # block never called during live-reindex, since prefix_index creates it
        unless exist?(index)
          create(index)
          Prompter.say_ok "#{index} index created" if options[:verbose]
        end

        if defined?(Mongoid::Document) && model.include?(Mongoid::Document)
          def model.find_in_batches(options={})
            0.step(count, options[:batch_size]) do |offset|
              yield limit(options[:batch_size]).skip(offset).to_a
            end
          end
        end

        unless model.respond_to?(:find_in_batches)
          Conf.logger.error "Model #{model} does not respond to :find_in_batches. Skipped."
          next
        end

        pbar = ProgBar.new(model.count, options[:batch_size], "Model #{model}: ") if options[:verbose]

        model.find_in_batches(:batch_size => options[:batch_size]) do |batch|
          result = Elastics.post_bulk_collection(batch, options[:import_options]) || next
          pbar.process_result(result, batch.size) if options[:verbose]
        end

        pbar.finish if options[:verbose]
      end
    end

  private

    def models
      @models ||= begin
                    models = options[:models] || Conf.elastics_models
                    raise ArgumentError, 'no class defined. Please use MODELS=ClassA,ClassB ' +
                                         'or set the Elastics::Configuration.elastics_models properly' \
                                         if models.nil? || models.empty?
                    models.map{|c| c.is_a?(String) ? eval("::#{c}") : c}
                  end
    end

  end

end
