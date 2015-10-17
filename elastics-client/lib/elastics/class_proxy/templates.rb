module Elastics
  module ClassProxy
    module Templates

      attr_reader :templates, :partials
      include Doc
      include Search

      def init
        @sources   = []
        @templates = {}
        @partials  = {}
      end

      # accepts a path to a file or YAML string
      def load_source_for(klass, source, source_vars)
        if source.nil? || source !~ /\n/m
          base_names = [source, Utils.class_name_to_path(context.name), Utils.class_name_to_type(context.name)]
          paths      = base_names.map{|bn| ["#{Conf.elastics_dir}/#{bn}.yml", "#{Conf.elastics_dir}/#{bn}.yml.erb"]}.flatten
          paths     << source.to_s
          source     = paths.find {|p| File.exist?(p)}
        end
        raise ArgumentError, "Unable to load the source: expected a string, got #{source.inspect}" \
              unless source.is_a?(String)
        @sources << [klass, source, source_vars]
        do_load_source(klass, source, source_vars)
        # fixes the legacy empty stubs, which should call super instead
        @templates.keys.each do |name|
          meta_context.send(:define_method, name){|*vars| super *vars }
        end
      end

      # loads a API Template source
      def load_api_source(source=nil, source_vars=nil)
        load_source_for(Elastics::Template::Api, source, source_vars)
      end

      # loads a Generic Template source
      def load_source(source=nil, source_vars=nil)
        load_source_for(Template, source, source_vars)
      end

      # loads a Search Template source
      def load_search_source(source=nil, source_vars=nil)
        load_source_for(Template::Search, source, source_vars)
      end

      # loads a SlimSearch Template source
      def load_slim_search_source(source=nil, source_vars=nil)
        load_source_for(Template::SlimSearch, source, source_vars)
      end

      # reloads the sources (useful in the console and used internally)
      def reload!
        @sources.each {|k,s,v| do_load_source(k,s,v)}
      end

      def wrap(*methods, &block)
        methods = templates.keys if methods.empty?
        methods.each do |name|
          raise MissingTemplateMethodError, "#{name} is not a template method" \
                unless templates.include?(name)
          meta_context.send(:define_method, name, &block)
        end
      end

      def render(name, *vars)
        templates[name].render(*vars)
      end

      private

      def do_load_source(klass, source, source_vars)
        source = Utils.erb_process(source) unless source.match("\n") # skips non-path
        hash   = Utils.parse_source(source)
        Utils.delete_allcaps_keys(hash).each do |name, args|
          define_template klass, name, args, source_vars
        end
      end

      def define_template(klass, name, args, source_vars)
        name = name.to_sym
        args = [args] unless args.is_a?(Array)
        if name.to_s[0] == '_' # partial
          partials[name] = Template::Partial.new(*args).setup(self, name)
        else
          templates[name] = klass.new(*args).setup(self, name, source_vars)
          context::ElasticsTemplateMethods.send(:define_method, name) do |*vars|
            raise ArgumentError, "#{elastics.context}.#{name} expects a list of Hashes, got #{vars.map(&:inspect).join(', ')}" \
                  unless vars.all?{|i| i.nil? || i.is_a?(Hash)}
            elastics.render(name,*vars)
          end
        end
      end

      def meta_context
        class << context; self end
      end

    end
  end
end
