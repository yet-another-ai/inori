# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe HTTPHeader do
  describe 'HTTPHeader' do
    it 'turns strings and symbols downcase' do
      hash = described_class.new
      hash['A'] = 1
      hash[:A] = 2
      expect(hash.keys).to eq(['a', :a])
    end

    it 'responds hash key in any case' do
      hash = described_class.new
      hash['A'] = 1
      hash[:A] = 2
      expect(hash.key?('a')).to be(true)
      expect(hash.key?(:a)).to be(true)
      expect(hash.key?('A')).to be(true)
      expect(hash.key?(:A)).to be(true)
      expect(hash['A']).to eq(1)
      expect(hash['a']).to eq(1)
      expect(hash[:A]).to eq(2)
      expect(hash[:a]).to eq(2)
    end

    it 'does not use keys other than string or symbol' do
      hash = described_class.new
      expect { hash[true] = 1 }.to raise_error(NoMethodError)
    end
  end
end
