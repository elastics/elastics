module Elastics
  module Rails
    class Logger < Elastics::Logger

      attr_accessor :log_to_rails_logger, :log_to_stderr

      def initialize(*)
        super
        self.formatter = proc do |severity, datetime, progname, msg|
          elastics_formatted = elastics_format(severity, msg)
          ::Rails.logger.send(severity.downcase.to_sym, elastics_formatted) if log_to_rails_logger && ::Rails.logger.respond_to?(severity.downcase.to_sym)
          elastics_formatted if log_to_stderr
        end
        @log_to_rails_logger = true
        @log_to_stderr       = false
      end

    end
  end
end
