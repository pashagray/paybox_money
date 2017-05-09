module PayboxMoney
  class Utility
    def self.flatten_hash(hash)
      hash.reduce({}) do |acc, pair|
        if pair[1].is_a?(Hash)
          acc.update(flatten_hash(pair[1]))
        else
          acc.update(pair[0] => pair[1])
        end
      end
    end

    def self.sort_hash(hash)
      hash.sort.reduce({}) do |acc, pair|
        if pair[1].is_a?(Hash)
          acc.update(pair[0] => sort_hash(pair[1]))
        else
          acc.update(pair[0] => pair[1])
        end
      end
    end
  end
end