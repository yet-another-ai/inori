# frozen_string_literal: true

##
# This class provides methods to be inherited as route definition.
module Inori
  class API
    class << self
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

      # Add DELETE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   delete '/' do
      #      puts 'Hello World'
      #   end
      def delete(path, &) end

      # Add GET method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   get '/' do
      #      puts 'Hello World'
      #   end
      def get(path, &) end

      # Add HEAD method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   head '/' do
      #      puts 'Hello World'
      #   end
      def head(path, &) end

      # Add POST method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   post '/' do
      #      puts 'Hello World'
      #   end
      def post(path, &) end

      # Add PUT method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   put '/' do
      #      puts 'Hello World'
      #   end
      def put(path, &) end

      # Add CONNECT method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   connect '/' do
      #      puts 'Hello World'
      #   end
      def connect(path, &) end

      # Add OPTIONS method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @return [nil] nil
      # @example String as router
      #   options '/' do
      #      puts 'Hello World'
      #   end
      def options(path, &) end

      # Add TRACE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   trace '/' do
      #      puts 'Hello World'
      #   end
      def trace(path, &) end

      # Add COPY method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   copy '/' do
      #      puts 'Hello World'
      #   end
      def copy(path, &) end

      # Add LOCK method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   lock '/' do
      #      puts 'Hello World'
      #   end
      def lock(path, &) end

      # Add MKCOK method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   mkcol '/' do
      #      puts 'Hello World'
      #   end
      def mkcol(path, &) end

      # Add MOVE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   move '/' do
      #      puts 'Hello World'
      #   end
      def move(path, &) end

      # Add PROPFIND method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   propfind '/' do
      #      puts 'Hello World'
      #   end
      def propfind(path, &) end

      # Add PROPPATCH method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   proppatch '/' do
      #      puts 'Hello World'
      #   end
      def proppatch(path, &) end

      # Add UNLOCK method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   unlock '/' do
      #      puts 'Hello World'
      #   end
      def unlock(path, &) end

      # Add REPORT method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   report '/' do
      #      puts 'Hello World'
      #   end
      def report(path, &) end

      # Add MKACTIVITY method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   mkactivity '/' do
      #      puts 'Hello World'
      #   end
      def mkactivity(path, &) end

      # Add CHECKOUT method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   checkout '/' do
      #      puts 'Hello World'
      #   end
      def checkout(path, &) end

      # Add MERGE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   merge '/' do
      #      puts 'Hello World'
      #   end
      def merge(path, &) end

      # Add M-SEARCH method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   msearch '/' do
      #      puts 'Hello World'
      #   end
      def msearch(path, &block)
        add_route(:'M-SEARCH', path, block)
      end

      # Add NOTIFY method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   notify '/' do
      #      puts 'Hello World'
      #   end
      def notify(path, &) end

      # Add SUBSCRIBE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   subscribe '/' do
      #      puts 'Hello World'
      #   end
      def subscribe(path, &) end

      # Add UNSUBSCRIBE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   unsubscribe '/' do
      #      puts 'Hello World'
      #   end
      def unsubscribe(path, &) end

      # Add PATCH method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   patch '/' do
      #      puts 'Hello World'
      #   end
      def patch(path, &) end

      # Add PURGE method as a DSL for route definition
      # @param [ String ] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [ nil ] nil
      # @example String as router
      #   purge '/' do
      #      puts 'Hello World'
      #   end
      def purge(path, &) end

      # Add LINK method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   link '/' do
      #      puts 'Hello World'
      #   end
      def link(path, &) end

      # Add UNLINK method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   unlink '/' do
      #      puts 'Hello World'
      #   end
      def unlink(path, &) end

      # Add WEBSOCKET method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   websocket '/' do
      #      puts 'Hello World'
      #   end
      def websocket(path, &) end

      # Add EVENTSOURCE method as a DSL for route definition
      # @param [String] path Accepts as part of path in route definition
      # @yield what to run when route matched
      # @return [nil] nil
      # @example String as router
      #   eventsource '/' do
      #      puts 'Hello World'
      #   end
      def eventsource(path, &) end

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
      def use(middleware, *)
        middleware = middleware.new(*)
        @scope_middlewares << middleware
        nil
      end

      # Use a middleware in the next route
      # @param [Class] middleware Inherited from +Inori::Middleware+
      # @return [nil] nil
      def filter(middleware, *)
        middleware = middleware.new(*)
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
