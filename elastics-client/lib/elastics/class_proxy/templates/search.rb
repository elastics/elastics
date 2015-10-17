module Elastics
  module ClassProxy
    module Templates
      module Search

        def define_search(name, source, source_vars=nil)
          args = Utils.parse_source(source)
          send :define_template, Template::Search, name, args, source_vars
        end

        # https://www.elastic.co/guide/en/elasticsearch/reference/current/search-multi-search.html
        # requests can be an array of arrays: [[:template1, variable_hash1], [template2, variable_hash2]]
        # or a hash {:template1 => variable_hash1, template2 => variable_hash2}
        # The variables are an hash of variables that will be used to render the msearch template
        # the array of result is at <result>.responses
        def multi_search(requests, *variables)
          requests = requests.map { |name, vars| [name, vars] } if requests.is_a?(Hash)
          lines    = requests.map { |name, vars| templates[name].to_msearch(vars) }.join()
          template = Elastics::Template.new('GET', '/<<index>>/<<type>>/_msearch') # no setup elastics so raw_result
          template.send(:do_render, *variables, :data => lines) do |http_response|
            responses   = []
            es_response = MultiJson.decode(http_response.body)
            es_response['responses'].each_with_index do |raw_result, i|
              name, vars = requests[i]
              int = templates[name].interpolate(vars, strict=true)
              result = Result.new(templates[name], int[:vars], http_response, raw_result)
              responses << result.to_elastics_result
            end
            es_response['responses'] = responses
            def es_response.responses
              self['responses']
            end
            es_response
          end
        end

        # implements search_type=scan (https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-search-type.html#scan)
        def scan_search(template, *vars, &block)
          user_raw_result = vars.any?{|v| v[:raw_result]}
          scroll      = '5m'
          search_vars = Vars.new({:params     => { :search_type => 'scan',
                                                   :scroll      => scroll,
                                                   :size        => 50 },
                                  :raw_result => true}, *vars)
          search_temp = template.is_a?(Elastics::Template) ? template : templates[template]

          scroll_vars = Vars.new({:params     => { :scroll => scroll },
                                  :raw_result => true}, variables, *vars)
          scroll_temp = Elastics::Template.new( :get,
                                            '/_search/scroll',
                                            nil,
                                            scroll_vars )
          search_res  = search_temp.render search_vars
          scroll_id   = search_res['_scroll_id']
          while (result = scroll_temp.render(:data => scroll_id)) do
            break if result['hits']['hits'].empty?
            scroll_id = result['_scroll_id']
            result.variables[:raw_result] = user_raw_result
            block.call result.to_elastics_result(force=true)
          end
        end

        # implements search_type=count (https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-search-type.html#count)
        def count_search(template, *vars)
          template = template.is_a?(Elastics::Template) ? template : templates[template]
          template.render Vars.new({:params => {:search_type => 'count'}, :raw_result => true}, *vars)
        end


        def method_missing(meth, *vars, &block)
          meth.to_s =~ /(\w+)_(exists?\??|valid\??|validate|count|explain)$/
          template_method = $1.to_sym
          return super unless respond_to?(template_method)

          render = lambda {|path| templates[template_method].render(Vars.new({:path => path, :raw_result => true}, *vars))}

          case meth.to_s

          # implements https://www.elastic.co/guide/en/elasticsearch/reference/current/search-exists.html
          when /exists?\??$/
            result = render.call '/<<index>>/<<type>>/<<id= ~ >>/_search/exists'
            result['exists']

          # implements https://www.elastic.co/guide/en/elasticsearch/reference/current/search-validate.html
          when /(_valid\??|validate)$/
            result = render.call '/<<index>>/<<type>>/<<id= ~ >>/_validate/query'
            result['valid']

          # implements the count API (https://www.elastic.co/guide/en/elasticsearch/reference/current/search-count.html)
          when /_count$/
            result = render.call '/<<index>>/<<type>>/_count'
            result['count']

          # implements https://www.elastic.co/guide/en/elasticsearch/reference/current/search-explain.html
          when /_explain$/
            render.call '/<<index>>/<<type>>/<<id= ~ >>/_explain'

          end
        end

      end
    end
  end
end
