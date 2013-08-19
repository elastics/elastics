module Elastics
  module ActiveModel

    attr_reader :_version, :_id, :highlight
    alias_method :id, :_id

    def self.included(base)
      base.class_eval do
        @elastics ||= ClassProxy::Base.new(base)
        @elastics.extend(ClassProxy::ModelSyncer)
        @elastics.extend(ClassProxy::ModelIndexer).init
        @elastics.extend(ClassProxy::ActiveModel).init :params => {:version => true}
        def self.elastics; @elastics end
        elastics.synced = [self]

        include Scopes
        include ActiveAttr::Model

        extend  ::ActiveModel::Callbacks
        define_model_callbacks :create, :update, :save, :destroy

        include Storage::InstanceMethods
        extend  Storage::ClassMethods
        include Inspection
        extend  Timestamps
        extend  Attachment
      end
    end

    def elastics
      @elastics ||= InstanceProxy::ActiveModel.new(self)
    end

    def elastics_source
      attributes
    end

    def elastics_indexable?
      true
    end

    def method_missing(meth, *args, &block)
      raw_document.respond_to?(meth) ? raw_document.send(meth) : super
    end

  end
end
