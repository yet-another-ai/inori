# frozen_string_literal: true

module Inori
  class << self
    # Return current logger inori is using
    # @return [Logger] the current logger inori is using
    def logger
      @logger ||= ::Logger.new($stdout)
    end

    # Return inori's logger
    # @param [Logger] logger set inori logger
    attr_writer :logger
  end
end
