module Elastics
  module ClassProxy
    module Templates
      module Doc

        class Output


          attr_reader :template, :method_call

          def initialize(name, proxy)
            @name, @template = proxy.templates.find do |n, t|
                                 t.is_a?(Elastics::Template::Api) && t.aliases.include?(name)
                               end || [ name, proxy.templates[name]]
            @method_call = [proxy.context, @name].join('.')

            sources = []
            sources << { :class  => @template.class,
                         :source => @template.to_source }
            @template.partials.each do |name|
              partial = proxy.partials[name]
              sources << { :class  => partial.class,
                           :source => partial.to_source }
            end
            @sources = sources
          end


          def render_usage(indent='')
            variables = @template.instance_eval do
                          interpolate
                          @base_variables.deep_merge @host_elastics && @host_elastics.variables, @temp_variables
                        end
            all_tags  = @template.tags + @template.partials
            return @method_call if all_tags.size == 0
            lines = all_tags.map do |t|
                      comments = 'partial' if t.to_s[0] == '_'
                      line     = ['', t.inspect]
                      line + if variables.has_key?(t)
                               ["#{variables[t].inspect},", comments_to_s(comments)]
                             else
                               ["#{to_code(t)},", comments_to_s(comments, 'required')]
                             end
                    end
            lines.sort! { |a,b| b[3] <=> a[3] }
            lines.first[0] = @method_call
            lines.last[2].chop!
            max       = lines.transpose.map{ |c| c.map(&:length).max }
            formatted = lines.map{ |line| "%-#{max[0]}s %-#{max[1]}s => %-#{max[2]}s  %s" % line }
            indented  = formatted.shift
            indented  = [indented] + formatted.map{ |line| indent + line }
            indented.join("\n") + "\n "
          end


          def comments_to_s(*comments)
            comments = comments.compact
            return '' if comments == []
            "# #{comments.join(' ')}"
          end


          def to_code(name)
            keys = name.to_s.split('.').map{ |s| s =~ /^[0..9]+$/ ? s.to_i : s.to_sym }
            code = keys.shift.to_s
            return code if keys.empty?
            keys.each { |k| code << "[#{k.inspect}]" }
            code
          end


          def render_sources
            @sources.map do |source|
              <<-output.gsub(/^ {12}/m,'')
              #{'-' * source[:class].name.length}
              #{source[:class]}
              #{source[:source]}
              output
            end.join("\n")
          end


          def render_api
            notice = if @template.is_a?(Elastics::Template::Api) && @template.references['notice']
                       "\nNotice: #{@template.references['notice']}\n "
                     end
            <<-output.gsub(/^ {12}/m,'')
            ########## #{@method_call} ##########

            API Name: #{@template.references['api_name']}
            API URL: #{@template.references['api_url']}

            #{render_sources}
            Usage:
            #{render_usage(' ' * 12)}#{ notice }
            output
          end


          def render_custom
            <<-output.gsub(/^ {12}/m,'')
            ########## #{@method_call} ##########

            #{render_sources}

            Usage:
            #{render_usage(' ' * 12)}
            output
          end


          def render_stub
            aliased  = if @template.is_a?(Elastics::Template::Api) && @template.references['aliases']
                         "\n# also aliased by: #{@template.aliases.map(&:inspect).join(', ')}"
                       end
            <<-output.gsub(/^ {12}/m,'')
            def self.#{@name}(*vars)
              ## this is a stub, used for reference
              super
            end#{ aliased }
            output
          end


          def render
            output = (@template.is_a?(Elastics::Template::Api) ? render_api : render_custom)
            output = output.split("\n").map{ |l| '#  ' + l }.join("\n")
            output << "\n#{render_stub}\n\n"
            output
          end

        end


        def doc(*names)
          names = templates.keys if names.empty?
          doc   = "\n"
          names.each do |name|
            next unless context.respond_to?(name)
            doc << Output.new(name, self).render
          end
          Prompter.say_log doc
        end


        def usage(name)
          Prompter.say_log "\n#{Output.new(name, self).render_usage}\n"
        end


        def find(pattern)
          pattern = /#{pattern}/ unless pattern.is_a?(Regexp)
          methods = templates.keys.select{ |key| key =~ pattern }
          Prompter.say_log methods.to_yaml
        end

      end
    end
  end
end
