require 'spec_helper'

RSpec.describe PayboxMoney::Payment::Init do
  describe '#new' do
    it 'filters unpermitted params' do
      init = PayboxMoney::Payment::Init.new(
        pg_sig: 'sdkjvbljadgf',
        pg_amount: '1000',
        pg_description: 'Test',
        pg_salt: 'asdlkhbfoadf',
        pg_merchant_id: '1',
        pg_language: 'ru',
        pg_unpermitted_param: 'unpermitted_param'
      )

      expect{ init.pg_unpermitted_param }.to raise_error(NoMethodError)
    end

    it 'raises error if any required params is not set' do
      init =

      expect{
        PayboxMoney::Payment::Init.new(
          pg_sig: 'sdkjvbljadgf',
          pg_amount: '1000',
          pg_description: 'Test',
          pg_salt: 'asdlkhbfoadf'
        )
      }.to raise_error(StandardError).with_message('[:pg_merchant_id] is required, but not set')
    end

    it 'sets params' do
      init = PayboxMoney::Payment::Init.new(
        pg_sig: 'sdkjvbljadgf',
        pg_amount: '1000',
        pg_description: 'Test',
        pg_salt: 'asdlkhbfoadf',
        pg_merchant_id: '1',
        pg_language: 'ru',
      )

      expect(init.pg_salt).to eq('asdlkhbfoadf')
    end
  end
end
