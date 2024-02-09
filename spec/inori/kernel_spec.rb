# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Kernel do
  describe 'Define Class' do
    it 'defineds an Error to be caught' do
      define_class('HelloError', StandardError)
      expect do
        raise HelloError
      end.to raise_error(HelloError)
    end
  end
end
