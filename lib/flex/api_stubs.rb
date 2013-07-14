module Flex
  module ApiStubs

    # The following lines are autogenerated by Flex.doc

    ######################## Core API ########################

    #  ########## Flex.store ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  store:
    #  - PUT
    #  - /<<index>>/<<type>>/<<id>>
    #
    #
    #  Usage:
    #  Flex.store :id    => id,    # required
    #             :type  => nil,
    #             :index => "flex_test_index"
    #
    def Flex.store(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_store ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_store:
    #  - PUT
    #  - /<<index>>/<<type>>/<<id>>
    #
    #
    #  Usage:
    #  Flex.put_store :id    => id,    # required
    #                 :type  => nil,
    #                 :index => "flex_test_index"
    #
    def Flex.put_store(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.post_store ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  post_store:
    #  - POST
    #  - /<<index>>/<<type>>
    #
    #
    #  Usage:
    #  Flex.post_store :index => "flex_test_index",
    #                  :type  => nil
    #
    def Flex.post_store(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete:
    #  - DELETE
    #  - /<<index>>/<<type>>/<<id>>
    #
    #
    #  Usage:
    #  Flex.delete :id    => id,    # required
    #              :type  => nil,
    #              :index => "flex_test_index"
    #
    def Flex.delete(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.remove ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  remove:
    #  - DELETE
    #  - /<<index>>/<<type>>/<<id>>
    #
    #
    #  Usage:
    #  Flex.remove :id    => id,    # required
    #              :type  => nil,
    #              :index => "flex_test_index"
    #
    def Flex.remove(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get:
    #  - GET
    #  - /<<index>>/<<type>>/<<id>>
    #
    #
    #  Usage:
    #  Flex.get :id    => id,    # required
    #           :type  => nil,
    #           :index => "flex_test_index"
    #
    def Flex.get(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_source ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_source:
    #  - GET
    #  - /<<index>>/<<type>>/<<id>>/_source
    #
    #
    #  Usage:
    #  Flex.get_source :id    => id,    # required
    #                  :type  => nil,
    #                  :index => "flex_test_index"
    #
    def Flex.get_source(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.multi_get ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  multi_get:
    #  - GET
    #  - /<<index>>/<<type>>/_mget
    #  - ids: << ids >>
    #
    #
    #  Usage:
    #  Flex.multi_get :ids   => ids,   # required
    #                 :type  => nil,
    #                 :index => "flex_test_index"
    #
    def Flex.multi_get(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.update ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  update:
    #  - POST
    #  - /<<index>>/<<type>>/<<id>>/_update
    #
    #
    #  Usage:
    #  Flex.update :id    => id,    # required
    #              :type  => nil,
    #              :index => "flex_test_index"
    #
    def Flex.update(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.percolate ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  percolate:
    #  - GET
    #  - /<<index>>/<<type>>/_percolate
    #
    #
    #  Usage:
    #  Flex.percolate :index => "flex_test_index",
    #                 :type  => nil
    #
    def Flex.percolate(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_percolator ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_percolator:
    #  - PUT
    #  - /_percolator/<<index>>/<<percolator>>
    #
    #
    #  Usage:
    #  Flex.put_percolator :percolator => percolator,  # required
    #                      :index      => "flex_test_index"
    #
    def Flex.put_percolator(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_percolator ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_percolator:
    #  - DELETE
    #  - /_percolator/<<index>>/<<percolator>>
    #
    #
    #  Usage:
    #  Flex.delete_percolator :percolator => percolator,  # required
    #                         :index      => "flex_test_index"
    #
    def Flex.delete_percolator(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.post_bulk_string ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  post_bulk_string:
    #  - POST
    #  - /_bulk
    #  - << bulk_string >>
    #
    #
    #  Usage:
    #  Flex.bulk :bulk_string => bulk_string  # required
    #
    def Flex.post_bulk_string(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.count ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  count:
    #  - GET
    #  - /<<index>>/<<type>>/_count
    #
    #
    #  Usage:
    #  Flex.count :index => "flex_test_index",
    #             :type  => nil
    #
    def Flex.count(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_by_query ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_by_query:
    #  - DELETE
    #  - /<<index>>/<<type>>/_query
    #
    #
    #  Usage:
    #  Flex.delete_by_query :index => "flex_test_index",
    #                       :type  => nil
    #
    def Flex.delete_by_query(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.more_like_this ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  more_like_this:
    #  - GET
    #  - /<<index>>/<<type>>/<<id>>/_mlt
    #
    #
    #  Usage:
    #  Flex.more_like_this :id    => id,    # required
    #                      :type  => nil,
    #                      :index => "flex_test_index"
    #
    def Flex.more_like_this(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.mlt ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  mlt:
    #  - GET
    #  - /<<index>>/<<type>>/<<id>>/_mlt
    #
    #
    #  Usage:
    #  Flex.mlt :id    => id,    # required
    #           :type  => nil,
    #           :index => "flex_test_index"
    #
    def Flex.mlt(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.validate ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  validate:
    #  - GET
    #  - /<<index>>/<<type>>/_validate/query
    #
    #
    #  Usage:
    #  Flex.validate :index => "flex_test_index",
    #                :type  => nil
    #
    def Flex.validate(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.explain ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  explain:
    #  - GET
    #  - /<<index>>/<<type>>/<<id>>/_explain
    #
    #
    #  Usage:
    #  Flex.explain :id    => id,    # required
    #               :type  => nil,
    #               :index => "flex_test_index"
    #
    def Flex.explain(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.match_all ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  match_all:
    #  - GET
    #  - /<<index>>/<<type>>/_search
    #  - query:
    #      match_all: {}
    #
    #
    #  Usage:
    #  Flex.match_all :index => "flex_test_index",
    #                 :type  => nil
    #
    def Flex.match_all(*vars)
      ## this is a stub, used for reference
      super
    end


    ######################## Indices API ########################

    #  ########## Flex.post_index_aliases ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  post_index_aliases:
    #  - POST
    #  - /_aliases
    #
    #
    #  Usage:
    #  Flex.post_index_aliases
    #
    def Flex.post_index_aliases(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_aliases ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_aliases:
    #  - GET
    #  - /<<index>>/_aliases
    #
    #
    #  Usage:
    #  Flex.get_index_aliases :index => "flex_test_index"
    #
    def Flex.get_index_aliases(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.add_index_alias ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  add_index_alias:
    #  - PUT
    #  - /<<index>>/_alias/<<alias>>
    #
    #
    #  Usage:
    #  Flex.add_index_alias :alias => alias,  # required
    #                       :index => "flex_test_index"
    #
    def Flex.add_index_alias(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_index_alias ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_index_alias:
    #  - DELETE
    #  - /<<index>>/_alias/<<alias>>
    #
    #
    #  Usage:
    #  Flex.delete_index_alias :alias => alias,  # required
    #                          :index => "flex_test_index"
    #
    def Flex.delete_index_alias(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_alias ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_alias:
    #  - GET
    #  - /<<index>>/_alias/<<alias= '*' >>
    #
    #
    #  Usage:
    #  Flex.get_index_alias :index => "flex_test_index",
    #                       :alias => "*"
    #
    def Flex.get_index_alias(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.analyze_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  analyze_index:
    #  - GET
    #  - /<<index>>/_analyze
    #
    #
    #  Usage:
    #  Flex.analyze_index :index => "flex_test_index"
    #
    def Flex.analyze_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_index:
    #  - PUT
    #  - /<<index>>
    #  - settings:
    #      number_of_shards: <<number_of_shards= 5 >>
    #      number_of_replicas: <<number_of_replicas= 1 >>
    #
    #
    #  Usage:
    #  Flex.put_index :index              => "flex_test_index",
    #                 :number_of_shards   => 5,
    #                 :number_of_replicas => 1
    #
    def Flex.put_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.create_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  create_index:
    #  - PUT
    #  - /<<index>>
    #  - settings:
    #      number_of_shards: <<number_of_shards= 5 >>
    #      number_of_replicas: <<number_of_replicas= 1 >>
    #
    #
    #  Usage:
    #  Flex.create_index :index              => "flex_test_index",
    #                    :number_of_shards   => 5,
    #                    :number_of_replicas => 1
    #
    def Flex.create_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.post_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  post_index:
    #  - POST
    #  - /<<index>>
    #  - settings:
    #      number_of_shards: <<number_of_shards= 5 >>
    #      number_of_replicas: <<number_of_replicas= 1 >>
    #
    #
    #  Usage:
    #  Flex.post_index :index              => "flex_test_index",
    #                  :number_of_shards   => 5,
    #                  :number_of_replicas => 1
    #
    def Flex.post_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_index:
    #  - DELETE
    #  - /<<index>>
    #
    #
    #  Usage:
    #  Flex.delete_index :index => "flex_test_index"
    #
    def Flex.delete_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.close_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  close_index:
    #  - POST
    #  - /<<index>>/_close
    #
    #
    #  Usage:
    #  Flex.close_index :index => "flex_test_index"
    #
    def Flex.close_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.open_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  open_index:
    #  - POST
    #  - /<<index>>/_close
    #
    #
    #  Usage:
    #  Flex.open_index :index => "flex_test_index"
    #
    def Flex.open_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_settings ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_settings:
    #  - GET
    #  - /<<index>>/_settings
    #
    #
    #  Usage:
    #  Flex.get_index_settings :index => "flex_test_index"
    #
    def Flex.get_index_settings(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_settings ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_settings:
    #  - GET
    #  - /<<index>>/_settings
    #
    #
    #  Usage:
    #  Flex.get_settings :index => "flex_test_index"
    #
    def Flex.get_settings(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_mapping:
    #  - GET
    #  - /<<index>>/<<type>>/_mapping
    #
    #
    #  Usage:
    #  Flex.get_index_mapping :index => "flex_test_index",
    #                         :type  => nil
    #
    def Flex.get_index_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_mapping:
    #  - GET
    #  - /<<index>>/<<type>>/_mapping
    #
    #
    #  Usage:
    #  Flex.get_mapping :index => "flex_test_index",
    #                   :type  => nil
    #
    def Flex.get_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_index_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_index_mapping:
    #  - PUT
    #  - /<<index>>/<<type>>/_mapping
    #  - <<type>>:
    #      properties: <<properties>>
    #
    #
    #  Usage:
    #  Flex.put_index_mapping :properties => properties,  # required
    #                         :type       => nil,
    #                         :index      => "flex_test_index"
    #
    def Flex.put_index_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_mapping:
    #  - PUT
    #  - /<<index>>/<<type>>/_mapping
    #  - <<type>>:
    #      properties: <<properties>>
    #
    #
    #  Usage:
    #  Flex.put_mapping :properties => properties,  # required
    #                   :type       => nil,
    #                   :index      => "flex_test_index"
    #
    def Flex.put_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_index_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_index_mapping:
    #  - DELETE
    #  - /<<index>>/<<type>>
    #
    #
    #  Usage:
    #  Flex.delete_index_mapping :index => "flex_test_index",
    #                            :type  => nil
    #
    def Flex.delete_index_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_mapping ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_mapping:
    #  - DELETE
    #  - /<<index>>/<<type>>
    #
    #
    #  Usage:
    #  Flex.delete_mapping :index => "flex_test_index",
    #                      :type  => nil
    #
    def Flex.delete_mapping(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.refresh_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  refresh_index:
    #  - POST
    #  - /<<index>>/_refresh
    #
    #
    #  Usage:
    #  Flex.refresh_index :index => "flex_test_index"
    #
    def Flex.refresh_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.optimize_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  optimize_index:
    #  - POST
    #  - /<<index>>/_optimize
    #
    #
    #  Usage:
    #  Flex.optimize_index :index => "flex_test_index"
    #
    def Flex.optimize_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.flush_index ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  flush_index:
    #  - POST
    #  - /<<index>>/_flush
    #
    #
    #  Usage:
    #  Flex.flush_index :index => "flex_test_index"
    #
    def Flex.flush_index(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.gateway_snapshot ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  gateway_snapshot:
    #  - POST
    #  - /<<index>>/_gateway/snapshot
    #
    #
    #  Usage:
    #  Flex.gateway_snapshot :index => "flex_test_index"
    #
    def Flex.gateway_snapshot(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.update_index_settings ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  update_index_settings:
    #  - PUT
    #  - /<<index>>/_settings
    #
    #
    #  Usage:
    #  Flex.update_index_settings :index => "flex_test_index"
    #
    def Flex.update_index_settings(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_index_template ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_index_template:
    #  - PUT
    #  - /_template/<<template>>
    #
    #
    #  Usage:
    #  Flex.put_index_template :template => template  # required
    #
    def Flex.put_index_template(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_index_template ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_index_template:
    #  - DELETE
    #  - /_template/<<template>>
    #
    #
    #  Usage:
    #  Flex.delete_index_template :template => template  # required
    #
    def Flex.delete_index_template(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_template ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_template:
    #  - GET
    #  - /_template/<<template>>
    #
    #
    #  Usage:
    #  Flex.get_index_template :template => template  # required
    #
    def Flex.get_index_template(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_index_warmer ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_index_warmer:
    #  - PUT
    #  - /<<index>>/<<type>>/_warmer/<<warmer>>
    #
    #
    #  Usage:
    #  Flex.put_index_warmer :warmer => warmer,  # required
    #                        :type   => nil,
    #                        :index  => "flex_test_index"
    #
    def Flex.put_index_warmer(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.delete_index_warmer ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  delete_index_warmer:
    #  - DELETE
    #  - /<<index>>/_warmer/<<warmer= ~ >>
    #
    #
    #  Usage:
    #  Flex.delete_index_warmer :index  => "flex_test_index",
    #                           :warmer => nil
    #
    def Flex.delete_index_warmer(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_index_warmer ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_index_warmer:
    #  - GET
    #  - /<<index>>/_warmer/<<warmer= ~ >>
    #
    #
    #  Usage:
    #  Flex.get_index_warmer :index  => "flex_test_index",
    #                        :warmer => nil
    #
    def Flex.get_index_warmer(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.index_stats ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  index_stats:
    #  - GET
    #  - /<<index>>/_stats/<<endpoint= ~ >>/<<names= ~ >>
    #
    #
    #  Usage:
    #  Flex.index_stats :index    => "flex_test_index",
    #                   :endpoint => nil,
    #                   :names    => nil
    #
    def Flex.index_stats(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.stats ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  stats:
    #  - GET
    #  - /<<index>>/_stats/<<endpoint= ~ >>/<<names= ~ >>
    #
    #
    #  Usage:
    #  Flex.stats :index    => "flex_test_index",
    #             :endpoint => nil,
    #             :names    => nil
    #
    def Flex.stats(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.index_status ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  index_status:
    #  - GET
    #  - /<<index>>/_status
    #
    #
    #  Usage:
    #  Flex.index_status :index => "flex_test_index"
    #
    def Flex.index_status(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.index_segments ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  index_segments:
    #  - GET
    #  - /<<index>>/_segments
    #
    #
    #  Usage:
    #  Flex.index_segments :index => "flex_test_index"
    #
    def Flex.index_segments(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.index_clearcache ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  index_clearcache:
    #  - POST
    #  - /<<index>>/_cache/clear
    #
    #
    #  Usage:
    #  Flex.index_clearcache :index => "flex_test_index"
    #
    def Flex.index_clearcache(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.indices_exists ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  indices_exists:
    #  - HEAD
    #  - /<<index>>
    #
    #
    #  Usage:
    #  Flex.indices_exists :index => "flex_test_index"
    #
    def Flex.indices_exists(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.exist? ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  exist?:
    #  - HEAD
    #  - /<<index>>
    #
    #
    #  Usage:
    #  Flex.exist? :index => "flex_test_index"
    #
    def Flex.exist?(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.types_exists ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  types_exists:
    #  - HEAD
    #  - /<<index>>/<<type>>
    #
    #
    #  Usage:
    #  Flex.types_exists :index => "flex_test_index",
    #                    :type  => nil
    #
    def Flex.types_exists(*vars)
      ## this is a stub, used for reference
      super
    end


    ######################## Cluster API ########################

    #  ########## Flex.cluster_health ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_health:
    #  - GET
    #  - /_cluster/health/<<index>>
    #
    #
    #  Usage:
    #  Flex.cluster_health :index => "flex_test_index"
    #
    def Flex.cluster_health(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_state ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_state:
    #  - GET
    #  - /_cluster/state
    #
    #
    #  Usage:
    #  Flex.cluster_state
    #
    def Flex.cluster_state(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.put_cluster_settings ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  put_cluster_settings:
    #  - PUT
    #  - /_cluster/settings
    #
    #
    #  Usage:
    #  Flex.put_cluster_settings
    #
    def Flex.put_cluster_settings(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.get_cluster_settings ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  get_cluster_settings:
    #  - GET
    #  - /_cluster/settings
    #
    #
    #  Usage:
    #  Flex.get_cluster_settings
    #
    def Flex.get_cluster_settings(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_nodes_info ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_nodes_info:
    #  - GET
    #  - /_nodes/<<nodes= ~ >>/<<endpoint= ~ >>
    #
    #
    #  Usage:
    #  Flex.cluster_nodes_info :nodes    => nil,
    #                          :endpoint => nil
    #
    def Flex.cluster_nodes_info(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_nodes_stats ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_nodes_stats:
    #  - GET
    #  - /_nodes/<<nodes= ~ >>/stats/<<endpoint= ~ >>
    #
    #
    #  Usage:
    #  Flex.cluster_nodes_stats :nodes    => nil,
    #                           :endpoint => nil
    #
    def Flex.cluster_nodes_stats(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_nodes_shutdown ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_nodes_shutdown:
    #  - POST
    #  - /_cluster/nodes/<<nodes= ~ >>/_shutdown
    #
    #
    #  Usage:
    #  Flex.cluster_nodes_shutdown :nodes => nil
    #
    def Flex.cluster_nodes_shutdown(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_nodes_hot_threads ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_nodes_hot_threads:
    #  - GET
    #  - /_nodes/<<nodes= ~ >>/hot_threads
    #
    #
    #  Usage:
    #  Flex.cluster_nodes_hot_threads :nodes => nil
    #
    def Flex.cluster_nodes_hot_threads(*vars)
      ## this is a stub, used for reference
      super
    end

    #  ########## Flex.cluster_reroute ##########
    #  --------------
    #  Flex::Template
    #  ---
    #  cluster_reroute:
    #  - POST
    #  - /_cluster/reroute
    #
    #
    #  Usage:
    #  Flex.cluster_reroute
    #
    def Flex.cluster_reroute(*vars)
      ## this is a stub, used for reference
      super
    end


  end
end
