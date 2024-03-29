# frozen_string_literal: true

module Inori
  ##
  # Abstract runner class to control instance of Inori Server
  # @attr [String] bind the address to bind
  # @attr [Integer] port the port to bind
  # @attr [Logger] logger inori logger
  class Runner
    attr_reader :bind, :port, :logger

    # Define status of a runner
    # @param [Class] api inherited from [Inori::API]
    def initialize(api)
      configure = Inori::Configure
      @logger = configure.logger
      Inori.logger = configure.logger
      @bind = configure.bind
      @port = configure.port
      @api = api.is_a? Inori::APIEngine ? api : Inori::APIEngine.new(api, configure.route_type)
      @before = configure.before
    end

    # Get Inori server whether running
    # @return [Boolean] [true] running
    # @return [Boolean] [false] not running
    def running?
      !!@server
    end

    # Start the Inori server
    # @note This is an async method, but no callback
    def start
      return false if running?

      init_socket
      @logger.info 'Inori is serving...'.blue
      Fiber.schedule do
        loop do
          conn = Inori::Connection.new(@server.accept)
          conn.server_initialize(@api, @logger)
          conn.listen
        end
      end
    end

    # Stop the Inori server
    # @note This is an async method, but no callback
    # @return [Boolean] [true] stop successfully
    # @return [Boolean] [false] nothing to stop
    def stop
      if running?
        @logger.info 'Stopping Inori'.blue
        @server.close
        @server = nil
        true
      else
        @logger.error 'Inori Server has NOT been started'.red
        false
      end
    end

    private

    def init_socket
      @logger.info "Inori #{Inori::VERSION} is now running on #{bind}:#{port}".blue

      @server = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
      @server.reuse_port if Inori::Configure.socket_reuse_port
      @server.bind Addrinfo.tcp @bind, @port
      @server.listen Socket::SOMAXCONN
      return unless Inori::Configure.tcp_fast_open

      tfo = @server.tcp_fast_open
      @logger.warn 'Failed to use TCP Fast Open feature on your OS'.yellow unless tfo
    end
  end
end
