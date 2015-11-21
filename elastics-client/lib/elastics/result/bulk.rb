module Elastics
  class Result
    module Bulk

      # extend if result comes from a bulk url
      def self.should_extend?(result)
        result.response.url =~ /\b_bulk\b/
      end

      def failed
        self['items'].reject{|i| i['index']['status'].between?(200,226) }
      end

      def successful
        self['items'].select{|i| i['index']['status'].between?(200,226) }
      end

    end
  end
end
