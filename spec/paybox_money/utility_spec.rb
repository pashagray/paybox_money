require 'spec_helper'

RSpec.describe PayboxMoney::Utility do
  hash = {
    c: 3,
    a: {
      aa: 11,
      ac: 13,
      ab: 12
    },
    d: 4,
    b: {
      ba: 21,
      bc:{
        bca: 231,
        bcc: 233,
        bcb: 232
      },
      bb:22
    }
  }

  describe '#flatten_hash' do
    result = {
      c: 3,
      aa: 11,
      ac: 13,
      ab: 12,
      d: 4,
      ba: 21,
      bca: 231,
      bcc: 233,
      bcb: 232,
      bb:22
    }

    it 'returns flattened hash' do
      expect(described_class.flatten_hash(hash)).to eq(result)
    end
  end

  describe '#sort_hash' do
    result = {
      a: {
        aa: 11,
        ab: 12,
        ac: 13
      },
      b: {
        ba: 21,
        bb: 22,
        bc: {
          bca: 231,
          bcb: 232,
          bcc: 233
        }
      },
      c: 3,
      d: 4
    }

    it 'returns sorted hash' do
      expect(described_class.sort_hash(hash)).to eq(result)
    end
  end
end
