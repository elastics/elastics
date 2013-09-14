require 'elastics-client'
require 'elastics-scopes'
require 'active_attr'

require 'elastics/class_proxy/model_syncer'
require 'elastics/instance_proxy/model_syncer'
require 'elastics/model_syncer'

require 'elastics/class_proxy/model_indexer'
require 'elastics/instance_proxy/model_indexer'
require 'elastics/model_indexer'

require 'elastics/active_model/timestamps'
require 'elastics/active_model/attachment'
require 'elastics/active_model/inspection'
require 'elastics/active_model/storage'
require 'elastics/class_proxy/active_model'
require 'elastics/instance_proxy/active_model'
require 'elastics/active_model'

require 'elastics/refresh_callbacks'

require 'elastics/models_live_reindex'

require 'elastics/result/document_loader'
require 'elastics/result/search_loader'
require 'elastics/result/active_model'

require 'elastics/model_tasks'

Elastics::LIB_PATHS << File.dirname(__FILE__)

# get_docs calls super so we make sure the result is extended by Scope first
Elastics::Conf.result_extenders  |= [ Elastics::Result::DocumentLoader,
                                     Elastics::Result::SearchLoader,
                                     Elastics::Result::ActiveModel ]
Elastics::Conf.elastics_models        = []
Elastics::Conf.elastics_active_models = []
