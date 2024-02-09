# frozen_string_literal: true

module Inori
  ##
  # Class for inori response
  # @attr [String] status HTTP response status
  # @attr [Hash] header HTTP response header
  # @attr [String] body HTTP response body
  class Response
    attr_accessor :status, :header, :body

    # @param [Hash] options HTTP response
    # @option options [Integer] code HTTP response code
    # @option options [Hash] header HTTP response header
    # @option options [String] body HTTP response body
    # Init a Response
    def initialize(options = {})
      code = options[:status] || 200
      @status = Inori::Const::STATUS_CODE[code]
      @header = options[:header] || Inori::Const::DEFAULT_HEADER.clone
      @body = options[:body] || ''
    end

    # Generate header string from hash
    # @return [String] generated string
    def generate_header
      if @header['Content-Length'].nil? && @header['Upgrade'].nil? && @header['Content-Type'] != 'text/event-stream'
        @header['Content-Length'] =
          @body.bytesize
      end
      @header.map do |key, value|
        "#{key}: #{value}\r\n"
      end.join
    end

    # Convert response to raw string
    # @return [String] generated string
    def to_s
      "HTTP/1.1 #{@status}\r\n#{generate_header}\r\n#{@body}"
    end
  end
end
