module PayboxMoney
  module Payment
    def self.default_params(params)
      Config.default_params = params
    end

    class Config
      class << self
        attr_writer :default_params

        def default_params
          @default_params || {}
        end
      end
    end
  end
end
