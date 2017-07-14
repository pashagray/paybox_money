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
      end.to raise_error(StandardError).with_message('[:merchant_id] is required, but not set')
    end

    it 'sets params' do
      init = PayboxMoney::Payment::Init.new(
        amount: '1000',
        description: 'Test',
        salt: 'asdlkhbfoadf',
        merchant_id: '500235',
        language: 'ru',
        secret_key: 'RmRVKviOifptexL'
      )

      puts init.to_hash
      puts init.response
      expect(init.response).to eq('asdlkhbfoadf')
    end
  end
end
