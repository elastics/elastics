require 'elastics-models'

env   = defined?(Rails) ? :environment : []

namespace :elastics do

  desc 'imports from an ActiveRecord or Mongoid models'
  task(:import => env) { Elastics::ModelTasks.new.import_models }

end
