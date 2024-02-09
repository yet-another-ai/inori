# frozen_string_literal: true

module Inori
  ##
  # This class provides methods for Websocket connection instance.
  # @attr [Array<Integer>, String] msg message send from client
  # @attr [Integer] opcode operation code of Websocket
  # @attr [Hash] events response for different event
  # @attr [Inori::Connection] connection raw EventMachine connection
  # @attr [Inori::Request] request raw request
  class Websocket
    attr_accessor :msg, :opcode, :events, :connection, :request

    # Init a Websocket instance with a connection
    # @param [Inori::Connection] connection raw EventMachine connection
    def initialize(connection)
      @events = {}
      @connection = connection
    end

    # API definition for events
    # @param [Symbol] event event name(open, message, close, ping, pong)
    # @yield what to do after event matched
    # @example
    #   websocket '/websocket' do |ws|
    #     ws.on :message do |msg|
    #       puts msg
    #     end
    #   end
    # open, message, close, ping, pong
    def on(event, &block)
      @events[event] = block
    end

    # Send data
    # @param [Array<Integer>, String] msg data to send
    def send(msg)
      output = []
      payload_length = []
      if msg.size < 126
        payload_length << msg.size
      elsif msg.size < 65_536
        payload_length << 126
        payload_length.concat([msg.size].pack('n').unpack('C*'))
      elsif msg.size < 2**63
        payload_length << 127
        payload_length.concat([msg.size >> 32, msg.size & 0xFFFFFFFF].pack('NN').unpack('C*'))
      else
        raise Inori::Exception::ContinuousFrame
      end

      if msg.is_a? String
        output << 0b10000001
        output.concat payload_length
        output.concat msg.unpack('C*')
        @connection.send_data(output.pack('C*'))
      elsif msg.is_a? Array
        output << 0b10000010
        output.concat payload_length
        output.concat msg
        @connection.send_data(output.pack('C*'))
      else
        raise Inori::Exception::OpCodeError
      end
    end

    # Send a Ping request
    # @param [String] str string to send
    def ping(str)
      heartbeat(0b10001001, str)
    end

    # Send a Pong request
    # @param [String] str string to send
    def pong(str)
      heartbeat(0b10001010, str)
    end

    # Ancestor of ping pong
    # @param [Integer] method opcode
    # @param [String] str string to send
    def heartbeat(method, str)
      raise Inori::Exception::PingPongSizeTooLarge if str.size > 125

      @connection.send_data [method, str.size, str].pack("CCA#{str.size}")
    end

    # Close a websocket connection
    def close
      raise Inori::Exception::FrameEnd
    end
  end
end
