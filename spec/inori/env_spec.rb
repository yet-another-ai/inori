require './spec/spec_helper'

RSpec.describe Inori do
  describe 'env' do
    it 'should be development by default' do
      expect(Inori.env).to eq('development')
      expect(Inori.env.development?).to eq(true)
      expect(Inori.env.production?).to eq(false)
    end

    it 'should be production after setting env' do
      ENV['INORI_ENV'] = 'production'
      expect(Inori.env).to eq('production')
      expect(Inori.env.development?).to eq(false)
      expect(Inori.env.production?).to eq(true)
    end
  end
end
