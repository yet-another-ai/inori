# frozen_string_literal: true

module Inori
  ##
  # This class provides methods for EventSource connection instance.
  # @attr [Inori::Connection] connection the connection instance of EventMachine
  class EventSource
    attr_accessor :connection

    # Init a EventSource instance with a connection
    # @param [Inori::Connection] connection the connection instance of EventMachine
    def initialize(connection)
      @connection = connection
    end

    # Send data and close the connection
    # @param [String] data data to be sent
    def send(data)
      raise Inori::Exception::EventSourceTypeError unless data.is_a? String

      # TODO: implement envents by standard
      @connection.send_data(data.split("\n").map { |str| "data: #{str}\n" }.join + "\n")
      @connection.close_connection_after_writing
    end
  end
end
