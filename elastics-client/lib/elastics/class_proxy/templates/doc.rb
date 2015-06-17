module Elastics
  module ClassProxy
    module Templates
      module Doc

        def doc(*names)
          names           = templates.keys if names.empty?
          grouped_methods = context.methods.group_by{|m| context.method(m)}
          get_aliases     = lambda{|name|grouped_methods[context.method(name)][1..-1]}
          doc             = "\n"
          names.each do |name|
            next unless context.respond_to?(name)
            name      = context.method(name).original_name unless templates.include?(name)
            temp      = templates[name]
            meth_call = [context, name].join('.')
            aliases   = get_aliases.call(name)
            aliased   = "\n# also aliased by: #{aliases.map(&:inspect).join(', ')}" unless aliases.empty?
            block     = ''
            block << <<-meth_call
########## #{meth_call} ##########
#{'-' * temp.class.to_s.length}
#{temp.class}
#{temp.to_source}
meth_call
            temp.partials.each do |par_name|
              par = partials[par_name]
              block << <<-partial
#{'-' * par.class.to_s.length}
#{par.class}
#{par.to_source}
partial
            end
            block << "\nUsage:\n"
            block << build_usage(meth_call, temp)
            block << "\n "
            doc << block.split("\n").map{|l| '#  ' + l}.join("\n")
            doc << <<-meth.gsub(/^ {14}/m,'')

def self.#{name}(*vars)
  ## this is a stub, used for reference
  super
end#{ aliased }


meth
          end
          Prompter.say_log doc
        end

        def usage(name)
          name      = context.method(name).original_name unless templates.include?(name)
          meth_call = [context, name].join('.')
          Prompter.say_log build_usage(meth_call, templates[name])
        end

      private

        def build_usage(meth_call, temp)
          variables = temp.instance_eval do
                        interpolate
                        @base_variables.deep_merge @host_elastics && @host_elastics.variables, @temp_variables
                      end
          all_tags  = temp.tags + temp.partials
          return meth_call if all_tags.size == 0
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
          lines.first[0] = meth_call
          lines.last[2].chop!
          max = lines.transpose.map { |c| c.map(&:length).max }
          lines.map { |line| "%-#{max[0]}s %-#{max[1]}s => %-#{max[2]}s  %s" % line }.join("\n")
        end

        def comments_to_s(*comments)
          comments = comments.compact
          return '' if comments == []
          "# #{comments.join(' ')}"
        end

        def to_code(name)
          keys = name.to_s.split('.').map{|s| s =~ /^[0..9]+$/ ? s.to_i : s.to_sym}
          code = keys.shift.to_s
          return code if keys.empty?
          keys.each{|k| code << "[#{k.inspect}]"}
          code
        end

      end
    end
  end
end
