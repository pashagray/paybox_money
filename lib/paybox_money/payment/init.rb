require 'nokogiri'
require 'nori'
require 'net/http'
require 'uri'
require 'securerandom'

module PayboxMoney
  module Payment
    class Init
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
      )

      REQUIRED_PARAMS = %i(
        merchant_id
        amount
        description
        salt
        sig
        secret_key
      )

      RESPONSE_PARAMS = %i(
        status
        redirect_url
        redirect_url_type
        error_code
        error_description
      )

      attr_reader *(PERMITTED_PARAMS + RESPONSE_PARAMS)

      def initialize(params = {})
        params
          .select { |p| PERMITTED_PARAMS.include?(p) }
          .each { |p| instance_variable_set("@#{p[0]}", p[1]) }

        @salt ||= SecureRandom.hex(10)
        @sig ||= Signature.new(
          secret_key: @secret_key,
          url: 'init_payment.php',
          params: to_hash
        ).result

        if missing_params.any?
          raise(
            StandardError,
            "#{missing_params} is required, but not set"
          )
        else
          request!
        end
      end

      def missing_params
        REQUIRED_PARAMS - REQUIRED_PARAMS.map { |p| p.to_sym if param_set?(p) }
      end

      def param_set?(param)
        !!send(param)
      end

      def to_hash
        PERMITTED_PARAMS
          .map { |p| ["pg_#{p}", send(p)] if param_set?(p) }
          .compact
          .to_h
      end

      def success?
        status == 'ok'
      end

      def request!
        uri = URI('https://www.paybox.kz/init_payment.php')
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Post.new(uri)
          req.set_form_data(to_hash)
          http.request(req)
        end
        build_response(res.body)
      end

      def build_response(response_body)
        res = Nori.new.parse(response_body)['response']
        res.each { |p| instance_variable_set("@#{p[0].sub('pg_', '')}", p[1]) }
      end
    end
  end
end
