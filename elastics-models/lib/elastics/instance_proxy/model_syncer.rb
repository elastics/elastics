module Elastics
  module InstanceProxy
    class ModelSyncer

      attr_reader :instance, :class_elastics

      def initialize(instance)
        @instance   = instance
        @class_elastics = instance.class.elastics
      end

      def sync(*trail)
        return if trail.include?(uid) || class_elastics.synced.nil?
        trail << uid
        class_elastics.synced.each do |synced|
          case
          # sync self
          when synced == instance.class
            sync_self
          # sync :author, :comments
          # works for all association types, if the instances have a #elastics proxy
          when synced.is_a?(Symbol)
            to_sync = instance.send(synced)
            if to_sync.respond_to?(:each)
              to_sync.each { |s| s.elastics.sync(*trail) }
            else
              to_sync.elastics.sync(*trail)
            end
          # sync 'blog'
          # polymorphic: use this form only if you want to sync any specific parent type but not all
          when synced.is_a?(String)
            next unless synced == parent_instance.elastics.type
            parent_instance.elastics.sync(*trail)
          else
            raise ArgumentError, "self, string or symbol expected, got #{synced.inspect}"
          end
        end
      end

      def uid
        @uid ||= [instance.class, instance.id].join('-')
      end

      def refresh_index
        class_elastics.refresh_index
      end

      def sync_self
        # nothing to sync, since a ModelSyncer cannot sync itselfs
      end

    end
  end
end
