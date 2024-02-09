# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Inori::Runner do
  describe 'Runner with default configure' do
    let(:runner) { EXAMPLE_RUNNER }

    after do
      runner.stop
      sleep 1
    end

    it 'does not stop before started' do
      expect(runner.stop).to be(false)
    end

    it 'starts properly' do
      expect do
        Thread.new { runner.start }
        sleep 1
      end.not_to raise_error(RuntimeError)
    end
  end
end
