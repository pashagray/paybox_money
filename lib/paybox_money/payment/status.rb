require 'nokogiri'
require 'nori'
require 'net/http'
require 'uri'
require 'securerandom'

module PayboxMoney
  module Payment
    class Status
      PERMITTED_PARAMS = %i(
        merchant_id
        payment_id
        salt
        sig
        secret_key
      )

      REQUIRED_PARAMS = %i(
        merchant_id
        payment_id
        salt
        sig
        secret_key
      )

      RESPONSE_PARAMS = %i(
        status
        payment_id
        transaction_status
        can_reject
        create_date
        result_date
        revoke_date
        payment_system
        accepted_payment_systems
        card_brand
        card_pan
        card_hash
        auth_code
        captured
      )

      attr_reader *(PERMITTED_PARAMS + RESPONSE_PARAMS)

      def initialize(params = {})
        params
          .select { |p| PERMITTED_PARAMS.include?(p) }
          .each { |p| instance_variable_set("@#{p[0]}", p[1]) }

        @salt ||= SecureRandom.hex(10)
        @sig ||= Signature.new(
          secret_key: @secret_key,
          url: 'get_status.php',
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
        uri = URI(GATEWAY_STATUS_PAYMENT)
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
