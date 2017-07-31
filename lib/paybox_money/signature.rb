module PayboxMoney
  #
  # Accept params and data to sort as required by paybox.money API and
  # generate signature based on these data.
  #
  # Example:
  # sig = Signature.new(url: 'payment_gateway', params: { pg_order_id: 123 })
  # sig.result # => 'fwf32r32g83f0n'
  #
  class Signature
    def initialize(url:, params:)
      @url = url
      @secret_key = params[:secret_key]
      # @params = params.reject { |k, _v| k == :secret_key }
      @params = params
    end

    def sorted_params
      Utility.sort_hash(@params)
    end

    def string_values
      [@url, Utility.flatten_hash(sorted_params).values].flatten.join(';')
    end

    def result
      Digest::MD5.hexdigest(string_values)
    end
  end
end
