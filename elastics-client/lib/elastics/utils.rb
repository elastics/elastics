module Elastics
  module Utils
    extend self

    def parse_source(source)
      return unless source
      parsed = case source
               when Hash              then keyfy(:to_s, source)
               when /^\s*\{.+\}\s*$/m then source
               when String            then YAML.load(source)
               else raise ArgumentError, "expected a String or Hash instance, got #{source.inspect}"
               end
      raise ArgumentError, "the source does not decode to an Array, Hash or String, got #{parsed.inspect}" \
            unless parsed.is_a?(Hash) || parsed.is_a?(Array) || parsed.is_a?(String)
      parsed
    end

    def erb_process(source)
      varname = "_elastics_#{source.hash.to_s.tr('-', '_')}"
      ERB.new(File.read(source), nil, nil, varname).result
    end

    def group_array_by(ary)
      h = {}
      ary.each do |i|
        k = yield i
        if h.has_key?(k)
          h[k] << i
        else
          h[k] = [i]
        end
      end
      h
    end

    def delete_allcaps_keys(hash)
      hash.keys.each { |k| hash.delete(k) if k =~ /^[A-Z_]+$/ }
      hash
    end

    def keyfy(to_what, obj)
      case obj
      when Hash
        h = {}
        obj.each do |k,v|
          h[k.send(to_what)] = keyfy(to_what, v)
        end
        h
      when Array
        obj.map{|i| keyfy(to_what, i)}
      else
        obj
      end
    end

    def slice_hash(hash, *keys)
      h = {}
      keys.each{|k| h[k] = hash[k] if hash.has_key?(k)}
      h
    end

    def env2options(*keys)
      options = {}
      ENV.keys.map do |k|
        key = k.downcase.to_sym
        options[key] = ENV[k] if keys.include?(key)
      end
      options
    end

    def define_delegation(opts)
      file, line = caller.first.split(':', 2)
      line = line.to_i

      obj, meth, methods, to = opts[:in], opts[:by], opts[:for], opts[:to]

      methods.each do |method|
        obj.send meth, <<-method, file, line - 1
          def #{method}(*args, &block)                        # def method_name(*args, &block)
            if #{to} || #{to}.respond_to?(:#{method})         #   if client || client.respond_to?(:name)
              #{to}.__send__(:#{method}, *args, &block)       #     client.__send__(:name, *args, &block)
            end                                               #   end
          end                                                 # end
        method
      end

    end

    def class_name_to_type(class_name)
      type = class_name.tr(':', '_')
      finalize_type(type)
    end

    def class_name_to_path(class_name)
      type = class_name.gsub('::', '/')
      finalize_type(type)
    end

    def type_to_class_name(type)
      type.gsub(/__(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    private

    def finalize_type(type)
      type.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      type.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      type.downcase!
      type
    end

  end
end
