require 'logger'

module Elastics
  class Logger < ::Logger


    attr_accessor :debug_variables, :debug_request, :debug_result, :curl_format

    def initialize(*)
      super
      self.level     = ::Logger::WARN
      self.progname  = 'ELASTICS'
      self.formatter = proc do |severity, datetime, progname, msg|
        elastics_format(severity, msg)
      end
      @debug_variables = true
      @debug_request   = true
      @debug_result    = true
      @curl_format     = false
    end

    def elastics_format(severity, msg)
      prefix = Dye.dye(" ELASTICS-#{severity} ", "ELASTICS-#{severity}:", :blue, :bold, :reversed) + ' '
      msg.split("\n").map{|l| prefix + l}.join("\n") + "\n"
    end

  end
end
