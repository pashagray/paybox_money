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
      ).freeze

      def initialize(params = {})
        super(
          permitted_params: PERMITTED_PARAMS,
          required_params: REQUIRED_PARAMS,
          url: STATUS_PAYMENT_URL,
          params: Config.default_params.merge(params)
        )
      end
    end
  end
end
