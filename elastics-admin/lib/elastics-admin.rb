require 'elastics-client'
require 'elastics/admin'
require 'elastics/admin_live_reindex'

Elastics::LIB_PATHS << File.dirname(__FILE__)

redis_installed = Gem::Specification.respond_to?(:find_all_by_name) ?
                    Gem::Specification::find_all_by_name('redis').any? :
                    Gem.available?('redis')

if redis_installed
  require 'redis'
  Elastics::Conf.redis = $redis || ::Redis.current
end
