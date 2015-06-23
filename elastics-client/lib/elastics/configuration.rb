module Elastics

  Configuration = OpenStruct.new :result_extenders => [ Result::Document,
                                                        Result::Search,
                                                        Result::MultiGet,
                                                        Result::Bulk ],
                                 :logger           => Logger.new(STDERR),
                                 :variables        => Vars.new( :params     => {},
                                                                :no_pruning => [] ),
                                 :config_file      => './config/elastics.yml',
                                 :elastics_dir     => './elastics',
                                 :http_client      => HttpClients::Loader.new_http_client

  # shorter alias
  Conf = Configuration

  Conf.instance_eval do
    def configure
      yield self
    end

    def indices
      @indices ||= Indices.new(config_file)
    end

    # force color in console (used with jruby)
    def ansi=(bool)
      Dye.color = bool
    end

    def ansi
      Dye.color?
    end
  end

end
