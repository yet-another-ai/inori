# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Inori do
  describe 'env' do
    it 'is development by default' do
      expect(described_class.env).to eq(:development)
      expect(described_class.env.development?).to be(true)
      expect(described_class.env.production?).to be(false)
    end

    it 'is production after setting env' do
      ENV['INORI_ENV'] = 'production'
      expect(described_class.env).to eq(:production)
      expect(described_class.env.development?).to be(false)
      expect(described_class.env.production?).to be(true)
    end
  end

  describe 'logger' do
    it 'always get non nil logger' do
      expect(described_class.logger).not_to be_nil
    end
  end
end
