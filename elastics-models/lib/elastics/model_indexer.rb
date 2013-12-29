module Elastics
  module ModelIndexer

    def self.included(base)
      base.class_eval do
        @elastics ||= ClassProxy::Base.new(base)
        @elastics.extend(ClassProxy::ModelSyncer)
        @elastics.extend(ClassProxy::ModelIndexer).init
        def self.elastics; @elastics end
        case
        when respond_to?(:find_in_batches)
          def self.elastics_in_batches(options={}, &block)
            find_in_batches(options, &block)
          end
        when defined?(Mongoid::Document) && include?(Mongoid::Document)
          def self.elastics_in_batches(options={}, &block)
            0.step(count, options[:batch_size]) do |offset|
              block.call limit(options[:batch_size]).skip(offset).to_a
            end
          end
        end
      end
    end

    def elastics
      @elastics ||= InstanceProxy::ModelIndexer.new(self)
    end

    def elastics_source
      attributes.reject {|k| k.to_s =~ /^_*id$/}
    end

    def elastics_indexable?
      true
    end

    def elastics_action
      'index'
    end

  end
end
