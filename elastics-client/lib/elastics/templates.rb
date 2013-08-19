module Elastics
  module Templates

    extend self
    attr_accessor :contexts
    @contexts = []

    def self.included(context)
      context.class_eval do
        Elastics::Templates.contexts |= [context]
        @elastics ||= ClassProxy::Base.new(context)
        @elastics.extend(ClassProxy::Templates).init
        def self.elastics; @elastics end
        def self.template_methods; elastics.templates.keys end
        eval "extend module #{context}::ElasticsTemplateMethods; self end"
      end
    end

  end
end
