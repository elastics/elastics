module Elastics
  module InstanceProxy
    class ModelIndexer < ModelSyncer

      # delegates :index, :is_child?, :is_parent? to class_elastics
      Utils.define_delegation :to  => :class_elastics,
                              :in  => self,
                              :by  => :module_eval,
                              :for => [:is_child?, :is_parent?]

      # indexes the document
      # usually called from after_save, you can eventually call it explicitly for example from another callback
      # or whenever the DB doesn't get updated by the model
      # you can also pass the :data=>elastics_source explicitly (useful for example to override the elastics_source in the model)
      def store(*vars)
        if instance.elastics_indexable?
          Elastics.store(metainfo, {:data => instance.elastics_source}, *vars)
        else
          Elastics.remove(metainfo, *vars) if Elastics.get(metainfo, *vars, :raise => false)
        end
      end

      # removes the document from the index (called from after_destroy)
      def remove(*vars)
        return unless instance.elastics_indexable?
        Elastics.remove(metainfo, *vars)
      end

      # gets the document from ES
      def get(*vars)
        return unless instance.elastics_indexable?
        Elastics.get(metainfo, *vars)
      end

      # like get, but it returns all the fields after a refresh
      def full_get(*vars)
        return unless instance.elastics_indexable?
        Elastics.search_by_id(metainfo, {:refresh => true, :params => {:fields => '*,_source'}}, *vars)
      end

      def parent_instance
        return unless is_child?
        @parent_instance ||= instance.send(class_elastics.parent_association) ||
                               raise(MissingParentError, "missing parent instance for document #{instance.inspect}.")
      end

      # helper that iterates through the parent record chain
      # record.elastics.each_parent{|p| p.do_something }
      def each_parent
        pi = parent_instance
        while pi do
          yield pi
          pi = pi.elastics.parent_instance
        end
      end

      def index
        @index ||= instance.respond_to?(:elastics_index) ? instance.elastics_index : class_elastics.index
      end
      attr_writer :index

      def type
        @type ||= case
                  when instance.respond_to?(:elastics_type) then instance.elastics_type
                  when is_child?                           then class_elastics.parent_child_map[parent_instance.elastics.type]
                  else                                          class_elastics.type
                  end
      end
      attr_writer :type

      def id
        @id ||= instance.respond_to?(:elastics_id) ? instance.elastics_id : instance.id.to_s
      end

      def routing
        @routing ||= case
                     when instance.respond_to?(:elastics_routing) then instance.elastics_routing
                     when is_child?                              then parent_instance.elastics.routing
                     when is_parent?                             then create_routing
                     end
      end
      attr_writer :routing

      def parent
        @parent ||= case
                    when instance.respond_to?(:elastics_parent) then instance.elastics_parent
                    when is_child?                             then parent_instance.id.to_s
                    else nil
                    end
      end
      attr_writer :parent

      def metainfo
        meta = Vars.new( :index => index, :type => type, :id => id )
        params = {}
        params[:routing] = routing if routing
        params[:parent]  = parent  if parent
        meta.merge!(:params => params) unless params.empty?
        meta
      end

      def sync_self
        instance.destroyed? ? remove : store
      end

      private

      BASE62_DIGITS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

      def create_routing
        string    = [index, type, id].join
        remainder = Digest::MD5.hexdigest(string).to_i(16)
        result    = []
        max_power = ( Math.log(remainder) / Math.log(62) ).floor
        max_power.downto(0) do |power|
          digit, remainder = remainder.divmod(62**power)
          result << digit
        end
        result << remainder if remainder > 0
        result.map{|digit| BASE62_DIGITS[digit]}.join
      end

    end
  end
end
