module Elastics
  class Tasks

    attr_reader :options

    def initialize(overrides={})
      options = Elastics::Utils.env2options *default_options.keys
      options[:index] = options[:index].split(',') if options[:index]
      @options = default_options.merge(options).merge(overrides)
    end

    def default_options
      @default_options ||= { :force => false,
                             :index => Conf.indices.keys }
    end

    def create_indices
      Conf.indices.delete_indices(options[:index]) if options[:force]
      Conf.indices.create_indices(options[:index])
    end

    def delete_indices
      Conf.indices.delete_indices(options[:index])
    end

  end
end
