module PayboxMoney

  class Signature
    def initialize(secret_key:, url:, params:)
      @secret_key = secret_key
      @url = url
      @params = params
    end

    def sorted_params
      Utility.sort_hash(@params)
    end

    def string_values
      [@url, Utility.flatten_hash(sorted_params).values, @secret_key].join(';')
    end

    def result
      Digest::MD5.hexdigest(string_values)
    end
  end
end
