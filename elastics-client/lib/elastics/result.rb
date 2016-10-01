module Elastics
  class Result < ::Hash

    attr_reader :template, :response
    attr_accessor :variables

    def initialize(template, variables, response, raw_result=nil)
      @template  = template
      @variables = variables
      @response  = response
      replace raw_result || !response.body.empty? && MultiJson.decode(response.body) || return
      Conf.result_extenders.each do |ext|
        next if ext.respond_to?(:should_extend?) && !ext.should_extend?(self)
        extend ext
      end
    end

    def to_elastics_result(force=false)
      return self if variables[:context].nil? || variables[:raw_result] &&! force
      variables[:context].respond_to?(:elastics_result) ? variables[:context].elastics_result(self) : self
    end

  end
end
