module PayboxMoney
  class ApiWrapper
    attr_reader :request, :response, :url

    def initialize(permitted_params:, required_params:, url:, params:)

      logger.info <<-HEREDOC
      '*--                                                      --*'
      '|                                                          |'
      "#{params}"
      '|                                                          |'
      '*_                                                        _*'
      HEREDOC


      @sig = Signature.new(
        url: url,
        params: params
      ).result
      @url = url
      @params = params.merge(sig: @sig).reject { |k, _v| k == :secret_key }
      @request = permitted_params.map { |p| ["pg_#{p}", @params[p]] if @params[p] }.compact.to_h
      if (required_params - @params.keys).any?
        raise(
          ParamsError,
          "#{(required_params - @params.keys)} is required, but not set"
        )
      else
        request!
      end
    end

    def success?
      @response && @response[:status] == 'ok'
    end

    def request!
      uri = URI(GATEWAY_URL + @url)
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(@request)
        http.request(req)
      end
      build_response(res.body)
    end

    def build_response(response_body)
      res = Nori.new.parse(response_body)['response']
      @response = res.map { |k, v| [k.to_s.sub('pg_', '').to_sym, v] }.to_h
    end
  end
end
