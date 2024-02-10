# frozen_string_literal: true

##
# This module store errors to be handled inside Inori
module Inori
  module Exception
    # No route matched
    class NotFound < StandardError; end
    # Internal Error
    class InternalError < StandardError; end
    # Inori doesn't support continuous frame of Websockets yet
    class ContinuousFrame < StandardError; end
    # Websocket OpCode not defined in RFC standards
    class OpCodeError < StandardError; end
    # Websocket request not masked
    class NotMasked < StandardError; end
    # Websocket frame has ended
    class FrameEnd < StandardError; end
    # Websocket Ping Pong size too large
    class PingPongSizeTooLarge < StandardError; end
    # Insert a not middleware class to middleware list
    class MiddlewareError < StandardError; end
  end
end
