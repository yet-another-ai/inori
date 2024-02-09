# frozen_string_literal: true

##
# Ancestor of all middlewares
module Inori
  class Middleware
    # Init a middleware
    def initialize; end

    # run before processing a request
    # @param [Inori::Request] request raw request
    # @return [Inori::Request] request to be further processed
    def before(request)
      request
    end

    # run after processing a request
    # @param [Inori::Request] _request raw request
    # @param [Inori::Response] response raw response
    # @return [Inori::Response] response to be further processed
    def after(_request, response)
      response
    end

    # Dynamically generate a method to use inside router
    # @param [Symbol] name name of the method
    # @yield the block to run
    def self.helper(name, &block)
      Inori::CleanRoom.class_exec do
        define_method(name, &block)
      end
    end
  end
end
