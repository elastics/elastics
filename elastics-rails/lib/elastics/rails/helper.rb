module Elastics
  module Rails
    module Helper
      extend self

      def after_initialize
        # we need to reload the elastics API methods with the new variables
        Elastics.reload!
        Conf.elastics_models && Conf.elastics_models.each {|m| eval"::#{m}" if m.is_a?(String) }
      end

    end
  end
end
