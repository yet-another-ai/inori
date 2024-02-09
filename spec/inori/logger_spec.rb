require './spec/spec_helper'

RSpec.describe Inori do
  describe 'logger' do
    it 'should always get non nil logger' do
      expect(Inori.logger).not_to be(nil)
    end
  end
end
