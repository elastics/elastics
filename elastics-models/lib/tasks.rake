require 'elastics-models'

env   = defined?(Rails) ? :environment : []

namespace :'elastics-client' do

  desc 'imports from an ActiveRecord or Mongoid models'
  task(:import => env) { Elastics::ModelTasks.new.import_models }

  task(:reset_redis_keys) { Elastics::Redis.reset_keys }

end
