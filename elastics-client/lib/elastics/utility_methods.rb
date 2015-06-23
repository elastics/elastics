module Elastics
  module UtilityMethods

    def search(data, vars={})
      Template::Search.new(data).setup(Elastics.elastics).render(vars)
    end

    # like Elastics.search, but it will use the Elastics::Template::SlimSearch instead
    def slim_search(data, vars={})
      Template::SlimSearch.new(data).setup(Elastics.elastics).render(vars)
    end

    %w[HEAD GET PUT POST DELETE].each do |m|
      class_eval <<-ruby, __FILE__, __LINE__
        def #{m}(*args)
          perform '#{m}', *args
        end
      ruby
    end

    def json2yaml(json)
      YAML.dump(MultiJson.decode(json))
    end

    def yaml2json(yaml)
      MultiJson.encode(YAML.load(yaml))
    end

    def reload!
      elastics.variables.deep_merge! Conf.variables
      Templates.contexts.each {|c| c.elastics.reload!}
      true
    end

    def doc(*args)
      elastics.doc(*args)
    end

    def usage(*args)
      elastics.usage(*args)
    end

    def scan_search(*args, &block)
      elastics.scan_search(*args, &block)
    end

    def scan_all(*vars, &block)
      elastics.scan_search(:match_all, *vars) do |raw_result|
        batch = raw_result['hits']['hits']
        block.call(batch)
      end
    end

    def dump_all(*vars, &block)
      refresh_index(*vars)
      scan_all({:params => {:fields => '*,_source'}}, *vars) do |batch|
        batch.map!{|document| document.delete('_score'); document}
        block.call(batch)
      end
    end

    # refresh and pull the full document from the index
    def dump_one(*vars)
      refresh_index(*vars)
      document = search_by_id({:params => {:fields => '*,_source'}}, *vars)
      document.delete('_score')
      document
    end

    # You should use Elastics.post_bulk_string if you have an already formatted bulk data-string
    def post_bulk_collection(collection, options={})
      raise ArgumentError, "Array expected as :collection, got #{collection.inspect}" \
            unless collection.is_a?(Array)
      bulk_string = ''
      collection.each do |d|
        bulk_string << build_bulk_string(d, options)
      end
      post_bulk_string(:bulk_string => bulk_string) unless bulk_string.empty?
    end

    def build_bulk_string(document, options={})
      case document
      when Hash
        bulk_string_from_hash(document, options)
      when Elastics::ModelIndexer, Elastics::ActiveModel
        bulk_string_from_elastics(document, options)
      else
        raise NotImplementedError, "Unable to convert the document #{document.inspect} to a bulk string."
      end
    end

  private

    def perform(*args)
      Template.new(*args).setup(Elastics.elastics).render
    end

    def bulk_string_from_hash(document, options)
      meta = Utils.slice_hash(document, '_index', '_type', '_id')
      if document.has_key?('fields')
        document['fields'].each do |k, v|
          meta[k] = v if k[0] == '_'
        end
      end
      source = document['_source'] unless options[:action] == 'delete'
      to_bulk_string(meta, source, options)
    end

    def bulk_string_from_elastics(document, options)
      elastics = document.elastics
      return '' unless document.elastics_indexable?
      options[:action] ||= document.elastics_action
      meta = { '_index' => elastics.index,
               '_type'  => elastics.type,
               '_id'    => elastics.id }
      meta['_parent']  = elastics.parent  if elastics.parent
      meta['_routing'] = elastics.routing if elastics.routing
      source           = document.elastics_source unless options[:action] == 'delete'
      to_bulk_string(meta, source, options)
    end

    def to_bulk_string(meta, source, options)
      action = options[:action] || 'index'
      return '' if (source.nil? || source.empty?) && (action != 'delete')
      meta['_index'] = LiveReindex.prefix_index(meta['_index']) if LiveReindex.should_prefix_index?
      bulk_string = MultiJson.encode(action => meta) + "\n"
      unless action == 'delete'
        source_line = source.is_a?(String) ? source : MultiJson.encode(source)
        return '' if source.nil? || source.empty?
        bulk_string << source_line + "\n"
      end
      bulk_string
    end

  end
end
