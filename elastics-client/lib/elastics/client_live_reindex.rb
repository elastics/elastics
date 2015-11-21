module Elastics
  module LiveReindex

    extend self

    # this method will be overridden by the elastics-admin gem
    def should_prefix_index?
      false
    end

    # this method will be overridden by the elastics-admin gem
    def should_track_change?
      false
    end

  end
end
