# frozen_string_literal: true

module Inori
  ##
  # This class provides methods to be inherited as route definition.
  class API
    class << self
      include Inori::APIRoutes
      # @!attribute routes
      #   @return [Hash] merged routes defined in the instance
      # @!attribute scope_middlewares
      #   @return [Array] global middlewares under the scope
      attr_accessor :routes, :scope_middlewares

      # Init private variables of class
      # @return [nil] nil
      def class_initialize
        @routes = {}
        Inori::Const::ROUTE_METHODS.map { |method| @routes[method] = [] }
        @routes[:MOUNT] = []
        @scope_middlewares = []
        @temp_middlewares = []
        nil
      end

      # Add M-SEARCH method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   msearch '/' do
      #      puts 'Hello World'
      #   end
      def msearch(path, &block)
        # Most of the routes has been added in `Inori::APIRoutes`, but not this one
        add_route(:'M-SEARCH', path, block)
      end

      # Mount a route prefix with another API defined
      # @param [String] prefix prefix of the route String
      # @param [Class] api inherited from Inori::API
      # @return [nil] nil
      def mount(prefix, api)
        raise ArgumentError if prefix == '/' # Cannot mount route API

        @routes[:MOUNT] << [prefix, api]
        nil
      end

      # Definitions for global error handler
      # @param [Class] error Error class, must be inherited form StandardError
      # @yield what to do to deal with error
      # @yieldparam [StandardError] e the detailed error
      # @example Basic Usage
      #   capture Inori::InternalError do |e|
      #     Inori::Response(500, {}, e.backtrace)
      #   end
      def capture(error, &block)
        Inori::Sandbox.add_rule(error, block)
        nil
      end

      # Use a middleware in the all routes
      # @param [Class] middleware Inherited from +Inori::Middleware+
      # @return [nil] nil
      def use(middleware, *args)
        middleware = middleware.new(*args)
        @scope_middlewares << middleware
        nil
      end

      # Use a middleware in the next route
      # @param [Class] middleware Inherited from +Inori::Middleware+
      # @return [nil] nil
      def filter(middleware, *args)
        middleware = middleware.new(*args)
        @temp_middlewares << middleware
        nil
      end

      # Helper block for defining methods in APIs
      # @param [Symbol] name name of the method
      # @yield define what to run in CleanRoom
      def helper(name, &block)
        Inori::CleanRoom.class_exec do
          define_method(name, &block)
        end
      end
    end

    # Constants of supported methods in route definition
    METHODS = %w[ delete
                  get
                  head
                  post
                  put
                  connect
                  options
                  trace
                  copy
                  lock
                  mkcol
                  move
                  propfind
                  proppatch
                  unlock
                  report
                  mkactivity
                  checkout
                  merge
                  notify
                  subscribe
                  unsubscribe
                  patch
                  purge
                  websocket
                  eventsource].freeze

    # Magics to fill DSL methods through dynamically class method definition
    METHODS.each do |method|
      define_singleton_method(method) do |*args, &block|
        add_route(method.upcase.to_sym, args[0], block) # args[0]: path
      end
    end

    singleton_class.send :alias_method, :ws, :websocket
    singleton_class.send :alias_method, :es, :eventsource

    private

    def inherited(subclass)
      super

      subclass.class_initialize
    end

    # Implementation of route DSL
    # @param [String] method HTTP method
    # @param [String, Regexp] path path definition
    # @param [Proc] block process to run when route matched
    # @return [nil] nil
    def add_route(method, path, block)
      # Argument check
      raise ArgumentError unless path.is_a? String

      # Insert route to routes
      route = Inori::Route.new(method, path, block)
      route.middlewares = @scope_middlewares + @temp_middlewares
      @routes[method] << route

      # Clean up temp middleware
      @temp_middlewares = []
      nil
    end
  end
end
