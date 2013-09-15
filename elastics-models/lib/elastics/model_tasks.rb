module Elastics

  class ModelTasks < Elastics::Tasks

    attr_reader :options

    def initialize(overrides={})
      options = Elastics::Utils.env2options *default_options.keys

      options[:timeout]    = options[:timeout].to_i      if options[:timeout]
      options[:batch_size] = options[:batch_size].to_i   if options[:batch_size]
      options[:models]     = options[:models].split(',') if options[:models]

      @options = default_options.merge(options).merge(overrides)
    end

    def default_options
      @default_options ||= { :force          => false,
                             :timeout        => 60,
                             :batch_size     => 500,
                             :models         => Conf.elastics_models,
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
            Elastics.delete_index(:index => index)
            deleted << index
            Prompter.say_warning "#{index} index deleted" if options[:verbose]
          end
        end

        # block never called during live-reindex, since prefix_index creates it
        unless Elastics.exist?(:index => index)
          Conf.indices.create_index(index)
          Prompter.say_ok "#{index} index created" if options[:verbose]
        end

        pbar = ProgBar.new(model.count, options[:batch_size], "Model #{model}: ") if options[:verbose]

        model.elastics_in_batches(:batch_size => options[:batch_size]) do |batch|
          result = Elastics.post_bulk_collection(batch) || next
          pbar.process_result(result, batch.size) if options[:verbose]
        end

        pbar.finish if options[:verbose]
      end
    end

  private

    def models
      @models ||= begin
                    models = options[:models]
                    raise ArgumentError, 'no class defined. Please use MODELS=ClassA,ClassB ' +
                                         'or set the Elastics::Configuration.elastics_models properly' \
                                         if models.nil? || models.empty?
                    models.map{|c| c.is_a?(String) ? eval("::#{c}") : c}
                  end
    end

  end

end
