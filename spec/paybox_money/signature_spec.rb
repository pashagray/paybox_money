require 'spec_helper'

RSpec.describe PayboxMoney::Signature do

  secret_key = 'mypasskey'
  url = 'script.php'
  params = {
    pg_t_param: 'value3',
    pg_a_param: 'value1',
    pg_z_param: {
      pg_q_subparam: 'subvalue2',
      pg_m_subparam: 'subvalue1'
    },
    pg_b_param: 'value2',
    pg_salt: '9imM909TH820jwk387'
  }

  result_values = 'script.php;value1;value2;9imM909TH820jwk387;value3;subvalue1;subvalue2;mypasskey'
  result_signature = 'a8a4d5a9188f24038a14a4d65c387bf7'

  it 'returns values in valid order' do
    expect(
      described_class.new(
        secret_key: secret_key,
        url: url,
        params: params
      ).string_values
    ).to eq(result_values)
  end

  it 'returns valid signature' do
    expect(
      described_class.new(
        secret_key: secret_key,
        url: url,
        params: params
      ).result
    ).to eq(result_signature)
  end
end
