require 'dye'
require 'yaml'
require 'ostruct'
require 'erb'
require 'multi_json'
require 'elastics/logger'
require 'elastics/errors'
require 'elastics/utils'

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
require 'elastics/configuration'
require 'elastics/utility_methods'

require 'progressbar'
require 'elastics/prog_bar'
require 'elastics/deprecation'

require 'elastics/api_stubs'
require 'elastics/tasks'

module Elastics

  VERSION   = File.read(File.expand_path('../../VERSION', __FILE__)).strip
  LIB_PATHS = [ File.dirname(__FILE__) ]


  include ApiStubs

  include Templates
  elastics.load_source File.expand_path('../elastics/api_templates/core_api.yml'   , __FILE__)
  elastics.load_source File.expand_path('../elastics/api_templates/indices_api.yml', __FILE__)
  elastics.load_source File.expand_path('../elastics/api_templates/cluster_api.yml', __FILE__)

  extend self
  extend UtilityMethods

  elastics.wrap :post_bulk_string, :bulk do |*vars|
    vars = Vars.new(*vars)
    return if vars[:bulk_string].nil? || vars[:bulk_string].empty?
    super vars
  end

  # get a document without using the get API (which doesn't support fields '*')
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
  elastics.wrap :store, :put_store, :post_store do |*vars|
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
  elastics.wrap :delete, :remove do |*vars|
    vars         = Vars.new(*vars)
    vars[:index] = LiveReindex.prefix_index(vars[:index]) if LiveReindex.should_prefix_index?
    if LiveReindex.should_track_change?
      vars.delete(:data)
      LiveReindex.track_change(:delete, dump_one(vars))
    end
    super(vars)
  end

end
