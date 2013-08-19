module Elastics
  class Template
    module Common

      attr_reader :name, :partials, :tags, :data

      def setup(host_elastics, name=nil, *vars)
        @host_elastics = host_elastics
        @name         = name
        @source_vars  = Vars.new(*vars) if is_a?(Elastics::Template)
        self
      end

      def interpolate_partials(vars)
        @partials.each do |name|
          partial_assigned_vars = vars[name]
          next if Prunable::VALUES.include?(partial_assigned_vars)
          vars[name] = case partial_assigned_vars
                       when Array
                         partial_assigned_vars.map {|v| @host_elastics.partials[name].interpolate(vars, v)}
                       # other partial name (usable as a case output)
                       when Symbol
                         @host_elastics.partials[partial_assigned_vars].interpolate(vars, vars[partial_assigned_vars])
                       # a partial object
                       when Template::Partial
                         partial_assigned_vars.interpolate(vars, vars)
                       # on-the-fly partial creation (an empty string would prune it before)
                       when String
                         Template::Partial.new(partial_assigned_vars).interpolate(vars, vars)
                       # switch to include the partial (a false value would prune it before)
                       when TrueClass
                         @host_elastics.partials[name].interpolate(vars, vars)
                       else
                         @host_elastics.partials[name].interpolate(vars, partial_assigned_vars)
                       end
        end
        vars
      end

    end
  end
end
