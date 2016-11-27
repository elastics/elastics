module Elastics

  # Generic Elastics::Template object.
  # This class represents a generic Elastics::Template object.
  # It is used as the base class by all the more specific Elastics::Template::* classes.
  # You  usually don't need to instantiate this class manually, since it is usually used internally.
  # For more details about templates, see the documentation.
  class Template

    include Logger
    include Common

    def self.variables
      Vars.new
    end

    attr_reader :method, :path

    def initialize(method, path, data=nil, *vars)
      @method = method.to_s.upcase
      raise ArgumentError, "#@method method not supported" \
            unless %w[HEAD GET PUT POST DELETE].include?(@method)
      @path          = path =~ /^\// ? path : "/#{path}"
      @data          = Utils.parse_source(data)
      @instance_vars = Vars.new(*vars)
    end

    def render(*vars)
      do_render(*vars) do |response, int|
        Result.new(self, int[:vars], response).to_elastics_result
      end
    end

    def to_a(*vars)
      vars = Vars.new(*vars)
      int  = interpolate(vars)
      a    = [method, int[:path], Utils.keyfy(:to_s, int[:data]), Utils.keyfy(:to_s, @instance_vars)]
      2.times { a.pop if a.last.nil? || a.last.empty? }
      a
    end

    def to_source
      {@name.to_s => to_a}.to_yaml
    end


  private

    def do_render(*vars)
      vars = Vars.new(*vars)
      int, path, encoded_data, response = try_clean_and_retry(vars)
      return response.status == 200 if method == 'HEAD' # used in Elastics.exist?
      if Conf.http_client.raise_proc.call(response)
        int[:vars][:raise].is_a?(FalseClass) ? return : raise(HttpError.new(response, caller_line))
      end
      result = yield(response, int)
    ensure
      log_render(int, path, encoded_data, result)
      result
    end

    # This allows to use Lucene style search language in the :cleanable_query declared variable and
    # in case of a syntax error it will remove all the problematic characters and retry with a cleaned query_string
    # http://lucene.apache.org/core/old_versioned_docs/versions/3_5_0/queryparsersyntax.html
    def try_clean_and_retry(vars)
      response_vars = request(vars)
      if !Prunable::VALUES.include?(vars[:cleanable_query].is_a?(Hash) ?
                                    vars[:cleanable_query][:query] :
                                    vars[:cleanable_query]) && Conf.http_client.raise_proc.call(response_vars[3])
        e = HttpError.new(response_vars[3], caller_line)
        e.to_hash['error'] =~ /^SearchPhaseExecutionException/
        # remove problematic characters in place (# + - && || ! ( ) { } [ ] ^ " ~ * ? : \ /)
        # see https://lucene.apache.org/core/5_5_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#Escaping_Special_Characters
        (vars[:cleanable_query].is_a?(Hash)? vars[:cleanable_query][:query] : vars[:cleanable_query]).tr!('+-&|!(){}[]^"~*?:\/', '')
         # if after the cleanup it is prunable, then we remove it now so #interpolate could use the eventual default
        if Prunable::VALUES.include?(vars[:cleanable_query].is_a?(Hash) ?
                                     vars[:cleanable_query][:query] :
                                     vars[:cleanable_query])
          if vars[:cleanable_query].is_a?(Hash)
            vars[:cleanable_query].delete(:query)
          else
            vars.delete(:cleanable_query)
          end
        end
        request vars
      else
        response_vars
      end
    end

    def request(vars)
      int          = interpolate(vars, strict=true)
      path         = build_path(int, vars)
      encoded_data = build_data(int, vars)
      response     = Conf.http_client.request(method, path, encoded_data)
      return int, path, encoded_data, response
    end

    def build_path(int, vars)
      params = int[:vars][:params]
      path   = vars[:path] || int[:path]
      unless params.empty?
        path << ((path =~ /\?/) ? '&' : '?')
        path << params.map { |p| p.join('=') }.join('&')
      end
      path
    end

    def build_data(int, vars)
      data = vars[:data] && Utils.parse_source(vars[:data]) || int[:data]
      (data.nil? || data.is_a?(String)) ? data : MultiJson.encode(data)
    end

    def interpolate(*args)
      tags             = Tags.new
      stringified      = tags.stringify(:path => @path, :data => @data)
      @partials, @tags = tags.partial_and_tag_names
      @base_variables  = Conf.variables.deep_merge(self.class.variables)
      @temp_variables  = Vars.new(@source_vars, @instance_vars, tags.variables)
      instance_eval <<-ruby, __FILE__, __LINE__
        def interpolate(vars={}, strict=false)
          vars = Vars.new(vars) unless vars.is_a?(Elastics::Vars)
          return {:path => path, :data => data, :vars => vars} if vars.empty? && !strict
          context_variables = vars[:context] ? vars[:context].elastics.variables : (@host_elastics && @host_elastics.variables)
          vars = @base_variables.deep_merge(context_variables, @temp_variables, vars).finalize
          vars = interpolate_partials(vars)
          obj  = #{stringified}
          obj  = Prunable.prune(obj, Prunable::Value)
          obj[:path].tr_s!('/', '/')     # removes empty path segments
          obj[:vars] = vars
          obj
        end
      ruby
      interpolate(*args)
    end

  end
end
