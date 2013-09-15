require 'elastics-client'

env = defined?(Rails) ? :environment : []

namespace :elastics do

  namespace :index do

    desc 'creates index/indices from the Elastics::Configuration.config_file file'
    task(:create => env) { Elastics::Tasks.new.create_indices }

    desc 'destroys index/indices in the Elastics::Configuration.config_file file'
    task(:delete => env) { Elastics::Tasks.new.delete_indices }

  end


end
