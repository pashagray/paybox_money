module PayboxMoney
  module Payment
    class Init < ApiWrapper

      def self.permitted_params
        %i(
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
        )
      end

      def self.required_params
        %i(
          merchant_id
          amount
          description
          salt
          sig
          secret_key
        )
      end

      def initialize(params = {})
        sig = Signature.new(
          secret_key: params[:secret_key],
          url: INIT_PAYMENT_URL,
          params: params
        ).result
        super(
          Init.permitted_params,
          Init.required_params,
          INIT_PAYMENT_URL,
          params.merge(sig: sig)
        )
      end
    end
  end
end
