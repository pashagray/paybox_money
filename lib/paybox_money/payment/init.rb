module PayboxMoney
  module Payment
    class Init < ApiWrapper
      PERMITTED_PARAMS = %i(
        merchant_id
        order_id
        amount
        currency
        chech_url
        result_url
        refund_url
        capture_url
        request_method
        success_url
        failure_url
        success_url_method
        failure_url_method
        state_url
        state_url_method
        site_url
        payment_system
        lifetime
        encoding
        description
        user_phone
        user_contact_email
        user_email
        user_ip
        language
        testing_mode
        recurring_start
        recurring_lifetime
        salt
        sig
        secret_key
        status
        redirect_url
        redirect_url_type
        error_code
        error_description
      ).freeze

      REQUIRED_PARAMS = %i(
        merchant_id
        amount
        description
        salt
        sig
      ).freeze

      def initialize(params = {})
        @params = Config.default_params.merge(params)
        @sig = Signature.new(
          url: INIT_PAYMENT_URL,
          params: @params
        )
        super(
          permitted_params: PERMITTED_PARAMS,
          required_params: REQUIRED_PARAMS,
          url: INIT_PAYMENT_URL,
          params: @params
            .merge(sig: @sig.result)
            .reject { |k, _v| k == :secret_key }
        )
      end
    end
  end
end
