module Elastics
  class Template
    class Api < Template

      attr_reader :references, :aliases

      def initialize(method, path, data=nil, *vars)
        super
        @references = @instance_vars.delete(:REFERENCES) || {}
        @aliases    = @references['aliases'] || []
      end

    end
  end
end
