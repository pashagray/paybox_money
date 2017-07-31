module PayboxMoney
  module Payment
    class Status < ApiWrapper
      PERMITTED_PARAMS = %i(
        merchant_id
        payment_id
        salt
        sig
        secret_key
      ).freeze

      REQUIRED_PARAMS = %i(
        merchant_id
        payment_id
        salt
        sig
      ).freeze

      def initialize(params = {})
        @params = Config.default_params.merge(params)
        @sig = Signature.new(
          url: STATUS_PAYMENT_URL,
          params: @params
        )
        puts @sig.string_values
        puts @sig.result
        super(
          permitted_params: PERMITTED_PARAMS,
          required_params: REQUIRED_PARAMS,
          url: STATUS_PAYMENT_URL,
          params: @params
            .merge(sig: @sig.result)
            .reject { |k, _v| k == :secret_key }
        )
      end
    end
  end
end
