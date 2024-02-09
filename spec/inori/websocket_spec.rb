# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Inori::Websocket do
  websocket = described_class.new(nil)
  describe 'decode' do
    it 'decodes masked Hello String correctly' do
      websocket.decode(StringIO.new([0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')))
      expect(websocket.msg).to eq('Hello')
    end

    it 'decodes masked Hello Array correctly' do
      websocket.decode(StringIO.new([0x82, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')))
      expect(websocket.msg).to eq([0x48, 0x65, 0x6c, 0x6c, 0x6f])
    end

    it 'does not decode unmasked Hello String' do
      expect do
        websocket.decode(StringIO.new([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f].pack('C*')))
      end.to raise_error(Inori::Exception::NotMasked)
    end
  end
end
