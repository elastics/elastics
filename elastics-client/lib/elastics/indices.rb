module Elastics
  class Indices < Hash

    extend Struct::Mergeable

    def initialize(config_path)
      hash = YAML.load(Utils.erb_process(config_path))
      replace Utils.delete_allcaps_keys(hash)
    end

    def create_index(index, name=nil, opts={})
      name ||= index
      Elastics.PUT name, self[index], opts
    end

    def create_indices(indices=keys, opts={})
      indices.each{|i| create_index(i, i, opts)}
    end

    def delete_indices(indices=keys, opts={})
      indices.each do |i|
        args = {:index=>i}.merge(opts)
        Elastics.delete_index(args)
      end
    end

  end
end
