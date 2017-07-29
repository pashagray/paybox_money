module PayboxMoney
  module Payment
    class Status
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
        secret_key
      ).freeze

      def initialize(params = {})
        sig = Signature.new(
          secret_key: params[:secret_key],
          url: STATUS_PAYMENT_URL,
          params: params
        ).result
        super(
          PERMITTED_PARAMS,
          REQUIRED_PARAMS,
          STATUS_PAYMENT_URL,
          params.merge(sig: sig)
        )
      end
    end
  end
end
