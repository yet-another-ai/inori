# frozen_string_literal: true

module Inori
  ##
  # Merge and manage all APIs.
  # @attr [Hash] routes A hash of all routes merged
  class APIEngine
    attr_accessor :routes

    # Init an API Engine
    # @param [Class] root_api API inherited from [Inori::API]
    # @param [Symbol] type type mustermann support
    def initialize(root_api, type = :sinatra)
      @routes = {}
      Inori::Const::ROUTE_METHODS.map { |method| @routes[method] = [] }
      @root_api = root_api
      @routes = merge('', root_api, [])
      @routes.delete :MOUNT
      @routes.each do |method|
        method[1].each do |route|
          route.path = Mustermann.new(route.path, type: type)
        end
      end
    end

    # Process after receive data from client
    # @param request [Inori::Request] Http Raw Request
    # @param connection [Inori::Connection] A connection created by EventMachine
    # @return [Inori::Response] Http Response
    # @raise [Inori::Error::NotFound] If no route matched
    def receive(request, connection = nil)
      @routes[request.method].each do |route|
        params = route.path.params(request.path)
        next unless params # Skip if not matched

        request.params = params
        clean_room = Inori::CleanRoom.new(request)
        if request.websocket?
          # Send 101 Switching Protocol
          connection.send_data Inori::Response.new(
            status: 101,
            header: Inori::APIEngine.websocket_header(request.header['Sec-Websocket-Key']),
            body: ''
          )
          connection.websocket.request = request
          Inori::Sandbox.run(clean_room, route.function, connection.websocket)
          return Inori::Response.new
        elsif request.eventsource?
          connection.send_data Inori::Response.new(
            status: 200,
            header: Inori::Const::EVENTSOURCE_HEADER
          )
          Inori::Sandbox.run(clean_room, route.function, connection.eventsource)
          return Inori::Response.new
        else
          request = middleware_exec(route.middlewares, clean_room, request)
          return request if request.is_a? Inori::Response # Early stop

          result = Inori::Sandbox.run(clean_room, route.function)
          clean_room.body = result
          response = result.is_a?(Inori::Response) ? result : clean_room.raw_response
          response = middleware_exec(route.middlewares, clean_room, request, response)
          return response
        end
      end
      raise Inori::Exception::NotFound
    end

    # Return websocket header with given key
    # @param [String] key 'Sec-Websocket-Key' in request header
    # @return [Hash] header
    def self.websocket_header(key)
      header = Inori::Const::WEBSOCKET_HEADER.clone
      header['Sec-Websocket-Accept'] = Digest::SHA1.base64digest("#{key}258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
      header
    end

    private

    # Merge all routes with a Depth-first search
    def merge(prefix, root_api, middlewares)
      root_api.routes[:MOUNT].each do |mount|
        root_api.routes.merge!(merge(mount[0], mount[1],
                                     root_api.scope_middlewares)) do |_key, old_val, new_val|
          old_val + new_val
        end
      end
      root_api.routes.delete :MOUNT
      root_api.routes.each do |method|
        method[1].each do |route|
          route.path = prefix + route.path
          route.middlewares = middlewares + route.middlewares
        end
      end
      root_api.routes
    end

    # Exec middlewares
    def middleware_exec(middlewares, clean_room, request, response = nil)
      result = response.nil? ? request : response
      middlewares.each do |middleware|
        result = if response.nil?
                   Inori::Sandbox.run(
                     clean_room,
                     proc { |req| middleware.before(req) },
                     result
                   )
                 else
                   Inori::Sandbox.run(
                     clean_room,
                     proc { |req, resp| middleware.after(req, resp) },
                     request,
                     result
                   )
                 end
        return result if response.nil? && result.is_a?(Inori::Response) # Early stop
      end
      result
    end
  end
end
