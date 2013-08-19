module Elastics

  module Deprecation

    extend self

    def warn(old, new, called=1)
      message = "#{old} is deprecated in favour of #{new}, and will be removed in a next version. Please, read the upgrade notes at http://elastics.github.io/elastics/doc/7-Tutorials/2-Migrate-from-0.x.html. "
      message << "(called at: #{caller[called]})" if called
      Conf.logger.warn message
    end

    module Module
      def extended(obj)
        Deprecation.warn(self, self::NEW_MODULE, 2)
        obj.extend self::NEW_MODULE
      end
      def included(base)
        Deprecation.warn(self, self::NEW_MODULE, 2)
        base.send :include, self::NEW_MODULE
      end
    end

  end

  ### Deprecation of Flex methods ###

  def info(*names)
    Deprecation.warn 'Flex.info', 'Elastics.doc'
    doc *names
  end

  def process_bulk(options={})
    Deprecation.warn 'Flex.process_bulk(:collection => collection)', 'Elastics.post_bulk_collection(collection, options)'
    post_bulk_collection(options.delete(:collection), options)
  end

  def import_collection(collection, options={})
    Deprecation.warn 'Flex.import_collection', 'Elastics.post_bulk_collection'
    post_bulk_collection(collection, options.merge(:action => 'index'))
  end

  def delete_collection(collection, options={})
    Deprecation.warn 'Flex.delete_collection(collection)', 'Elastics.post_bulk_collection(collection, :action => "delete")'
    post_bulk_collection(collection, options.merge(:action => 'delete'))
  end

  def bulk(*vars)
    Deprecation.warn 'Flex.bulk(:lines => lines_bulk_string)', 'Elastics.post_bulk_string(:bulk_string => lines_bulk_string)'
    vars = Vars.new(*vars)
    post_bulk_string(:bulk_string => vars[:lines])
  end


  ### Deprecation of Configuration methods ###

  Configuration.instance_eval do
    # temprary deprecation warnings
    def base_uri
      Deprecation.warn 'Flex::Configuration.base_uri', 'Elastics::Configuration.http_client.base_uri'
      http_client.base_uri
    end
    def base_uri=(val)
      Deprecation.warn 'Flex::Configuration.base_uri=', 'Elastics::Configuration.http_client.base_uri='
      http_client.base_uri = val
    end
    def http_client_options
      Deprecation.warn 'Flex::Configuration.http_client_options', 'Elastics::Configuration.http_client.options'
      http_client.options
    end
    def http_client_options=(val)
      Deprecation.warn 'Flex::Configuration.http_client_options=', 'Elastics::Configuration.http_client.options='
      http_client.options = val
    end
    def raise_proc
      Deprecation.warn 'Flex::Configuration.raise_proc', 'Elastics::Configuration.http_client.raise_proc'
      http_client.raise_proc
    end
    def raise_proc=(val)
      Deprecation.warn 'Flex::Configuration.raise_proc=', 'Elastics::Configuration.http_client.raise_proc='
      http_client.raise_proc = val
    end
  end


  class Variables
    def add(*hashes)
      Deprecation.warn 'Flex::Variables#add', 'Elastics::Variables#deep_merge!'
      replace deep_merge(*hashes)
    end
  end


  module Struct::Mergeable
    def add(*hashes)
      Deprecation.warn 'Flex::Variables#add', 'Variables#deep_merge!'
      replace deep_merge(*hashes)
    end
  end


  module Loader
    NEW_MODULE = Templates
    extend Deprecation::Module
  end


  module ClassProxy::Loader
    NEW_MODULE = ClassProxy::Templates
    extend Deprecation::Module
  end


  module ClassProxy::Templates
    module Doc
      def info(*names)
        Deprecation.warn 'flex.info', 'elastics.doc'
        doc *names
      end
    end
  end


  module Result::Collection
    NEW_MODULE = Struct::Paginable
    extend Deprecation::Module
  end


  module Model
    def self.included(base)
      if defined?(Flex::ModelIndexer)
        Deprecation.warn 'Flex::Model', 'Elastics::ModelIndexer'
        base.send :include, Elastics::ModelIndexer
      else
        raise NotImplementedError,  %(Elastics does not include "Flex::Model" anymore. Please, require the "elastics-models" gem, and include "Elastics::ModelIndexer" instead.)
      end
    end
  end


  module RelatedModel
    def self.included(base)
      if defined?(Flex::ModelSyncer)
        Deprecation.warn 'Flex::RelatedModel', 'Elastics::ModelSyncer'
        base.send :include, Elastics::ModelSyncer
      else
        raise NotImplementedError, %(Elastics does not include "Flex::RelatedModel" anymore. Please, require the "elastics-models" gem, and include "Elastics::ModelSyncer" instead.)
      end
    end
  end

end
