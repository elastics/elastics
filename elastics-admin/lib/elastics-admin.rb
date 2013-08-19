require 'elastics'
require 'elastics/admin'
require 'elastics/live_reindex'

Elastics::LIB_PATHS << File.dirname(__FILE__)

Elastics::Conf.redis = $redis || defined?(::Redis) && ::Redis.current
