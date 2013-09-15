module Elastics
  class ModelsIndices < Indices

    def initialize(config_path)
      default = {}.extend Struct::Mergeable
      (Conf.elastics_models + Conf.elastics_active_models).each do |m|
        m = eval"::#{m}" if m.is_a?(String)
        default.deep_merge! m.elastics.default_mapping
      end
      replace default.deep_merge(super)
    end

  end
end
