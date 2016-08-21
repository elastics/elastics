require 'dye'
require 'prompter'
require 'ruby-progressbar'
require 'yaml'
require 'ostruct'
require 'erb'
require 'multi_json'
require 'elastics/logger'
require 'elastics/errors'
require 'elastics/utils'

require 'elastics/struct/mergeable'
require 'elastics/struct/prunable'
require 'elastics/struct/symbolize'
require 'elastics/struct/hash'
require 'elastics/struct/array'

require 'elastics/variables'

require 'elastics/result'
require 'elastics/struct/paginable'
require 'elastics/result/document'
require 'elastics/result/search'
require 'elastics/result/multi_get'
require 'elastics/result/bulk'

require 'elastics/template/common'
require 'elastics/template/partial'
require 'elastics/template/logger'
require 'elastics/template'
require 'elastics/template/api'
require 'elastics/template/search'
require 'elastics/template/slim_search'
require 'elastics/template/tags'

require 'elastics/class_proxy/base'
require 'elastics/class_proxy/templates/search'
require 'elastics/class_proxy/templates/doc'

require 'elastics/class_proxy/templates'

require 'elastics/templates'

require 'elastics/http_clients/base'
require 'elastics/http_clients/loader'
require 'elastics/indices'
require 'elastics/configuration'
require 'elastics/utility_methods'

require 'elastics/prog_bar'
require 'elastics/client_live_reindex'

require 'elastics/api_stubs'
require 'elastics/tasks'

module Elastics

  LIB_PATHS = [ File.dirname(__FILE__) ]


  include ApiStubs

  include Templates
  elastics.load_api_source File.expand_path('../elastics/api_templates/document_api.yml'       , __FILE__)
  elastics.load_api_source File.expand_path('../elastics/api_templates/search_api.yml'         , __FILE__)
  elastics.load_api_source File.expand_path('../elastics/api_templates/indices_api.yml'        , __FILE__)
  elastics.load_api_source File.expand_path('../elastics/api_templates/cat_api.yml'            , __FILE__)
  elastics.load_api_source File.expand_path('../elastics/api_templates/cluster_api.yml'        , __FILE__)
  elastics.load_api_source File.expand_path('../elastics/api_templates/elastics_additions.yml' , __FILE__)

  extend self
  extend UtilityMethods

  ### wrapped methods ###

  elastics.wrap :cat do |*vars|
    if vars.first.is_a?(String)
      super :path => vars.first
    else
      super *vars
    end
  end

  elastics.wrap :post_bulk_string do |*vars|
    vars = Vars.new(*vars)
    return if vars[:bulk_string].nil? || vars[:bulk_string].empty?
    super vars
  end

  # get a document without using the get API and without raising any error if missing
  elastics.wrap :search_by_id do |*vars|
    vars   = Vars.new(*vars)
    result = super(vars)
    doc    = result['hits']['hits'].first
    class << doc; self end.class_eval do
      define_method(:raw_result){ result }
    end
    doc
  end

  # support for live-reindex
  elastics.wrap :store, :post_store do |*vars|
    vars         = Vars.new(*vars)
    vars[:index] = LiveReindex.prefix_index(vars[:index]) if LiveReindex.should_prefix_index?
    result = super(vars)
    if LiveReindex.should_track_change?
      vars.delete(:data)
      LiveReindex.track_change(:index, dump_one(vars))
    end
    result
  end

  # support for live-reindex
  elastics.wrap :delete do |*vars|
    vars         = Vars.new(*vars)
    vars[:index] = LiveReindex.prefix_index(vars[:index]) if LiveReindex.should_prefix_index?
    if LiveReindex.should_track_change?
      vars.delete(:data)
      LiveReindex.track_change(:delete, dump_one(vars))
    end
    super(vars)
  end

    ### alias methods ###

  class << self
    alias_method :put_store,          :store                 # for symmetry with post_store
    alias_method :remove,             :delete
    alias_method :multi_get,          :multi_get_ids         # deprecated (backward compatibility)
    alias_method :bulk,               :post_bulk_string      # deprecated (backward compatibility)

    alias_method :create_index,       :put_index
    alias_method :index_exists,       :indices_exists
    alias_method :exist?,             :indices_exists        # deprecated (backward compatibility)
    alias_method :put_mapping,        :put_index_mapping
    alias_method :type_exists,        :types_exists
    alias_method :put_index_settings, :update_index_settings

    alias_method :mlt,                :more_like_this
    alias_method :termvector,         :termvectors           # deprecated (backward compatibility)
  end


end
