module Elastics
  module ModelSyncer

    def self.included(base)
      base.class_eval do
        @elastics ||= ClassProxy::Base.new(base)
        @elastics.extend(ClassProxy::ModelSyncer)
        def self.elastics; @elastics end
      end
    end

    def elastics
      @elastics ||= InstanceProxy::ModelSyncer.new(self)
    end

  end
end
