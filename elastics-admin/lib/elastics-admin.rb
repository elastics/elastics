require 'elastics-client'
require 'elastics/admin'
require 'elastics/admin_live_reindex'

Elastics::LIB_PATHS << File.dirname(__FILE__)

Elastics::Conf.redis = $redis || defined?(::Redis) && ::Redis.current
