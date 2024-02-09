module Inori
  class << self
    # Return current logger inori is using
    # @return [Logger] the current logger inori is using
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end

    # Return inori's logger
    # @param [Logger] logger set inori logger
    def logger=(logger)
      @logger = logger
    end
  end
end
