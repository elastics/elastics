require 'elastics-client'

env   = defined?(Rails) ? :environment : []

namespace :'elastics-client' do

  # deprecated tasks
  task(:create_indices => env) do
    Elastics::Deprecation.warn 'flex:create_indices', 'elastics:index:create', nil
    Elastics::Tasks.new.create_indices
  end
  task(:delete_indices => env) do
    Elastics::Deprecation.warn 'flex:delete_indices', 'elastics:index:delete', nil
    Elastics::Tasks.new.delete_indices
  end

  namespace :index do

    desc 'creates index/indices from the Elastics::Configuration.config_file file'
    task(:create => env) { Elastics::Tasks.new.create_indices }

    desc 'destroys index/indices in the Elastics::Configuration.config_file file'
    task(:delete => env) { Elastics::Tasks.new.delete_indices }

  end


end
