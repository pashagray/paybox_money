require 'nokogiri'

module PayboxMoney
  module Payment
    class Init
      REQUEST_URL = 'https://www.paybox.kz/init_payment.php'
      PERMITTED_PARAMS = %i(
        pg_merchant_id
        pg_order_id
        pg_amount
        pg_currency
        pg_chech_url
        pg_result_url
        pg_refund_url
        pg_capture_url
        pg_request_method
        pg_success_url
        pg_failure_url
        pg_success_url_method
        pg_failure_url_method
        pg_state_url
        pg_state_url_method
        pg_site_url
        pg_payment_system
        pg_lifetime
        pg_encoding
        pg_description
        pg_user_phone
        pg_user_contact_email
        pg_user_email
        pg_user_ip
        pg_language
        pg_testing_mode
        pg_recurring_start
        pg_recurring_lifetime
        pg_salt
        pg_sig
      )

      REQUIRED_PARAMS = %i(
        pg_merchant_id
        pg_amount
        pg_description
        pg_salt
        pg_sig
      )

      attr_reader *PERMITTED_PARAMS

      def initialize(params = {})
        params
          .select { |p| PERMITTED_PARAMS.include?(p) }
          .each { |p| instance_variable_set("@#{p[0]}", p[1])}
        if missing_params.any?
          raise StandardError, "#{missing_params} is required, but not set"
        else
          # request!
        end
      end

      def missing_params
        REQUIRED_PARAMS - REQUIRED_PARAMS.map { |p| p.to_sym if param_set?(p) }
      end

      def param_set?(param)
        !!send(param)
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.request do
            PERMITTED_PARAMS.each { |p| xml.send(p, self.send(p)) if param_set?(p) }
          end
        end
      end
    end
  end
end
