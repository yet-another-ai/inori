# frozen_string_literal: true

module Inori
  ##
  # This class is used to be sandbox of requests processing.
  # @attr [Integer] status HTTP response code
  # @attr [Hash] header HTTP response header
  # @attr [Object] body HTTP response body. String could is accepted by default, but could leave for further process with +Inori::Middleware+
  # @attr [Inori::Request] request HTTP request
  class CleanRoom
    attr_accessor :status, :header, :body, :request

    # Init a Cleanroom for running
    # @param [Inori::Request] request HTTP request
    def initialize(request)
      @status = 200
      @header = Inori::Const::DEFAULT_HEADER.clone
      @body = ''
      @request = request
    end

    # Generate response from variables inside +Inori::CleanRoom+
    # @return [Inori::Response] inori response
    def raw_response
      Inori::Response.new(status: @status, header: @header, body: @body)
    end
  end
end
