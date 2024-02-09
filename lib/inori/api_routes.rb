# frozen_string_literal: true

module Inori
  ##
  # for routes placeholders
  module APIRoutes
    # Add DELETE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   delete '/' do
    #      puts 'Hello World'
    #   end
    def delete(path, &block) end

    # Add GET method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   get '/' do
    #      puts 'Hello World'
    #   end
    def get(path, &block) end

    # Add HEAD method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   head '/' do
    #      puts 'Hello World'
    #   end
    def head(path, &block) end

    # Add POST method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   post '/' do
    #      puts 'Hello World'
    #   end
    def post(path, &block) end

    # Add PUT method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   put '/' do
    #      puts 'Hello World'
    #   end
    def put(path, &block) end

    # Add CONNECT method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   connect '/' do
    #      puts 'Hello World'
    #   end
    def connect(path, &block) end

    # Add OPTIONS method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @return [nil] nil
    # @example String as router
    #   options '/' do
    #      puts 'Hello World'
    #   end
    def options(path, &block) end

    # Add TRACE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   trace '/' do
    #      puts 'Hello World'
    #   end
    def trace(path, &block) end

    # Add COPY method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   copy '/' do
    #      puts 'Hello World'
    #   end
    def copy(path, &block) end

    # Add LOCK method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   lock '/' do
    #      puts 'Hello World'
    #   end
    def lock(path, &block) end

    # Add MKCOK method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   mkcol '/' do
    #      puts 'Hello World'
    #   end
    def mkcol(path, &block) end

    # Add MOVE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   move '/' do
    #      puts 'Hello World'
    #   end
    def move(path, &block) end

    # Add PROPFIND method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   propfind '/' do
    #      puts 'Hello World'
    #   end
    def propfind(path, &block) end

    # Add PROPPATCH method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   proppatch '/' do
    #      puts 'Hello World'
    #   end
    def proppatch(path, &block) end

    # Add UNLOCK method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   unlock '/' do
    #      puts 'Hello World'
    #   end
    def unlock(path, &block) end

    # Add REPORT method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   report '/' do
    #      puts 'Hello World'
    #   end
    def report(path, &block) end

    # Add MKACTIVITY method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   mkactivity '/' do
    #      puts 'Hello World'
    #   end
    def mkactivity(path, &block) end

    # Add CHECKOUT method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   checkout '/' do
    #      puts 'Hello World'
    #   end
    def checkout(path, &block) end

    # Add MERGE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   merge '/' do
    #      puts 'Hello World'
    #   end
    def merge(path, &block) end

    # Add NOTIFY method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   notify '/' do
    #      puts 'Hello World'
    #   end
    def notify(path, &block) end

    # Add SUBSCRIBE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   subscribe '/' do
    #      puts 'Hello World'
    #   end
    def subscribe(path, &block) end

    # Add UNSUBSCRIBE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   unsubscribe '/' do
    #      puts 'Hello World'
    #   end
    def unsubscribe(path, &block) end

    # Add PATCH method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   patch '/' do
    #      puts 'Hello World'
    #   end
    def patch(path, &block) end

    # Add PURGE method as a DSL for route definition
    # @param [ String ] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [ nil ] nil
    # @example String as router
    #   purge '/' do
    #      puts 'Hello World'
    #   end
    def purge(path, &block) end

    # Add LINK method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   link '/' do
    #      puts 'Hello World'
    #   end
    def link(path, &block) end

    # Add UNLINK method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   unlink '/' do
    #      puts 'Hello World'
    #   end
    def unlink(path, &block) end

    # Add WEBSOCKET method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   websocket '/' do
    #      puts 'Hello World'
    #   end
    def websocket(path, &block) end

    # Add EVENTSOURCE method as a DSL for route definition
    # @param [String] path Accepts as part of path in route definition
    # @yield what to run when route matched
    # @return [nil] nil
    # @example String as router
    #   eventsource '/' do
    #      puts 'Hello World'
    #   end
    def eventsource(path, &block) end
  end
end
