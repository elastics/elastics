module Elastics
  module InstanceProxy
    class ActiveModel < ModelIndexer

      def store(*vars)
        return super unless instance.elastics_indexable? # this should never happen since elastics_indexable? returns true
        meth = (id.nil? || id.empty?) ? :post_store : :put_store
        Elastics.send(meth, metainfo, {:data => instance.elastics_source}, *vars)
      end

      def sync_self
        instance.instance_eval do
          if destroyed?
            if @skip_destroy_callbacks
              elastics.remove
            else
              run_callbacks :destroy do
                elastics.remove
              end
            end
          else
            run_callbacks :save do
              context = new_record? ? :create : :update
              run_callbacks(context) do
                result    = context == :create ? elastics.store : elastics.store(:params => { :version => _version })
                @_id      = result['_id']
                @_version = result['_version']
              end
            end
          end
        end
      end

    end
  end
end
