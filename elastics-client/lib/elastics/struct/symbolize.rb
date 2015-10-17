module Elastics
  module Struct
    module AsIs end
    module Symbolize

      def symbolize(obj)
        case obj
        when Elastics::Struct::Hash, Elastics::Struct::Array, Elastics::Struct::AsIs
          obj
        when ::Hash
          h = Elastics::Struct::Hash.new
          obj.each do |k,v|
            h[k.to_sym] = symbolize(v)
          end
          h
        when ::Array
          a = Elastics::Struct::Array.new
          obj.each{|i| a << i}
          a
        else
          obj
        end
      end

    end
  end
end
