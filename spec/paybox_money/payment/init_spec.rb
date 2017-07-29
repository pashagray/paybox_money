require 'spec_helper'

RSpec.describe PayboxMoney::Payment::Init do
  describe '#new' do
    it 'filters unpermitted params' do
      init = PayboxMoney::Payment::Init.new(
        sig: 'sdkjvbljadgf',
        amount: '1000',
        description: 'Test',
        salt: 'asdlkhbfoadf',
        merchant_id: '1',
        language: 'ru',
        secret_key: 'some_key',
        unpermitted_param: 'unpermitted_param'
      )

      expect { init.unpermitted_param }.to raise_error(NoMethodError)
    end

    it 'raises error if any required params is not set' do
      expect do
        PayboxMoney::Payment::Init.new(
          sig: 'sdkjvbljadgf',
          amount: '1000',
          description: 'Test',
          secret_key: 'some_key',
          salt: 'asdlkhbfoadf'
        )
      end.to raise_error(PayboxMoney::ParamsError).with_message('[:merchant_id] is required, but not set')
    end

    it 'uses default params if provided' do
      expect do
        PayboxMoney::Payment.default_params({ merchant_id: 500235 })
        PayboxMoney::Payment::Init.new(
          sig: 'sdkjvbljadgf',
          amount: '1000',
          description: 'Test',
          secret_key: 'some_key',
          salt: 'asdlkhbfoadf'
        )
      end.not_to raise_error
    end

    it 'makes successful request' do
      init = PayboxMoney::Payment::Init.new(
        amount: '1000',
        description: 'Test',
        salt: 'asdlkhbfoadf',
        merchant_id: '500235',
        language: 'ru',
        secret_key: 'RmRVKviOifpqtexL'
      )

      expect(init.success?).to eq(true)
    end

    it 'makes unsuccessful request' do
      init = PayboxMoney::Payment::Init.new(
        amount: '1000',
        description: 'Test',
        salt: 'asdlkhbfoadf',
        merchant_id: '500235',
        language: 'ru',
        secret_key: 'sdfsdfsd'
      )

      expect(init.success?).to eq(false)
    end
  end
end
