module Elastics
  module ClassProxy
    class Base

      attr_accessor :variables

      def initialize(context, vars={})
        v = {:context => context}
        # support for elastics-rails index default
        v[:index]  = Conf.variables[:index] if Conf.variables.has_key?(:index)
        @variables = Vars.new(v, vars)
      end

      def init; end

      [:context, :index, :type].each do |meth|
        define_method meth do
          variables[meth]
        end
        define_method :"#{meth}=" do |val|
          variables[meth] = val
        end
      end

      def refresh_index
        Elastics.refresh_index :index => index
      end

    end
  end
end
