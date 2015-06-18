module Elastics
  class Template
    class SlimSearch < Search

      # no _source returned
      # the result.loaded_collection, will load the records from the db
      def self.variables
        super.deep_merge!(:params => {:_source => false})
      end

    end
  end
end
