module Elastics
  # private module
  module LiveReindex

    def reindex_models(opts={})
      raise NotImplementedError, 'Elastics::LiveReindex.reindex_models requires the "elastics-admin" gem. Please, install it.' \
            unless defined?(Elastics::Admin)

      on_each_change do |action, document|
        if action == 'index'
          begin
            { action => document.load! }
          rescue Mongoid::Errors::DocumentNotFound, ActiveRecord::RecordNotFound
            nil # record already deleted
          end
        else
          { action => document }
        end
      end

      yield self if block_given?

      opts[:verbose]  = true unless opts.has_key?(:verbose)

      # we override the on_reindex eventually set
      on_reindex do
        opts = opts.merge(:force => false)
        ModelTasks.new(opts).import_models
      end

      perform(opts)
    end

    def reindex_active_models(opts={})
      Conf.http_client.options[:timeout] = opts[:timeout] || 60

      raise NotImplementedError, 'Elastics::LiveReindex.reindex_models requires the "elastics-admin" gem. Please, install it.' \
            unless defined?(Elastics::Admin)

      yield self if block_given?

      opts[:verbose]  = true unless opts.has_key?(:verbose)
      opts[:models] ||= Conf.elastics_active_models

      # we override the on_reindex eventually set
      on_reindex do
        opts[:models].each do |model|
          model = eval("::#{model}") if model.is_a?(String)
          raise ArgumentError, "The model #{model.name} is not a standard Elastics::ActiveModel model" \
                unless model.include?(Elastics::ActiveModel)

          pbar = ProgBar.new(model.count, nil, "Model #{model}: ") if opts[:verbose]

          model.find_in_batches({:raw_result => true, :params => {:fields => '*,_source'}}, opts) do |result|
            batch  = result['hits']['hits']
            result = process_and_post_batch(batch)
            pbar.process_result(result, batch.size) if opts[:verbose]
          end

          pbar.finish if opts[:verbose]

        end
      end

      perform(opts)
    end

  end
end
