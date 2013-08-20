require 'elastics-client'
require 'elastics-admin'

env = defined?(Rails) ? :environment : []

namespace :'elastics-client' do
  namespace :admin do

    desc 'Dumps the data from one or more Elasticsearch indices to a file'
    task(:dump => env) { Elastics::Admin::Tasks.new.dump_to_file }

    desc 'Loads a dumpfile into Elasticsearch'
    task(:load => env) { Elastics::Admin::Tasks.new.load_from_file }

  end

end
