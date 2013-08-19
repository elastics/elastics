module Elastics
  module ModelIndexer

    def self.included(base)
      base.class_eval do
        @elastics ||= ClassProxy::Base.new(base)
        @elastics.extend(ClassProxy::ModelSyncer)
        @elastics.extend(ClassProxy::ModelIndexer).init
        def self.elastics; @elastics end
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

  end

end
