require 'spec_helper'

RSpec.describe PayboxMoney::Signature do

  url = 'script.php'
  params = {
    t_param: 'value3',
    a_param: 'value1',
    secret_key: 'mypasskey',
    z_param: {
      q_subparam: 'subvalue2',
      m_subparam: 'subvalue1'
    },
    b_param: 'value2',
    salt: '9imM909TH820jwk387'
  }

  result_values = 'script.php;value1;value2;9imM909TH820jwk387;value3;subvalue1;subvalue2;mypasskey'
  result_signature = 'a8a4d5a9188f24038a14a4d65c387bf7'

  it 'returns values in valid order' do
    expect(
      described_class.new(
        url: url,
        params: params
      ).string_values
    ).to eq(result_values)
  end

  it 'returns valid signature' do
    expect(
      described_class.new(
        url: url,
        params: params
      ).result
    ).to eq(result_signature)
  end
end
