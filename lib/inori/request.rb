# frozen_string_literal: true

module Inori
  ##
  # Request class for inori
  # @attr [String] ip client ip address
  # @attr [Integer] port client port
  # @attr [String] ip parsed ip address
  # @attr [String] protocol protocol version of HTTP request
  # @attr [Symbol] method HTTP method
  # @attr [String] path request path
  # @attr [Hash] query_params parameter parsed from query string
  # @attr [String | nil] query_string request query string
  # @attr [HTTPHeader] header request header
  # @attr [String] body request body
  # @attr [Hash] cookie cookie hash coming from request
  # @attr [Boolean] parsed whether the request header parsed
  # @attr [Boolean] body_parsed whether the request body parsed
  # @attr [Hash] params params in the url
  class Request
    attr_accessor :ip, :port, :remote_ip,
                  :protocol, :method, :path, :query_params, :query_string,
                  :header, :body, :parsed, :body_parsed, :params, :cookie

    # Init Request
    def initialize
      @header = HTTPHeader.new
      @parsed = false
      @body_parsed = false
      @is_websocket = false
      @ip = ''
      @port = 0
      @parser = Mizu::Parser.new
      @params = {}
      @query_params = Hash.new([])
      @cookie = {}
      @body = ''
      @parser.on_complete do
        @protocol = @parser.version
        @method = @parser.method
        @path = @parser.path
        # Turn header into case-insensitive due to RFC 2.6 Chapter 4.2
        # https://www.ietf.org/rfc/rfc2616.txt
        @parser.headers.each { |key, value| @header[key] = value }
        @remote_ip = parse_ip || @ip # Detect client real IP with RFC 7239

        @query_string = @path.match(/\?(.*?)$/)
        unless @query_string.nil?
          @query_string = @query_string[1]
          @query_params = CGI.parse(@query_string)
        end

        @cookie = CGI::Cookie.parse(@header['Cookie']) unless @header['Cookie'].nil?
        @path.gsub!(/\?(.*?)$/, '')
        @method = @method.to_sym
        @parsed = true
      end
    end

    def reset!
      @header = HTTPHeader.new
      @parsed = false
      @body_parsed = false
      @is_websocket = false
      @parser.reset!
      @params = {}
      @query_params = Hash.new([])
      @cookie = {}
      @body = ''
    end

    # Init an request with String data
    # @param [String] data
    # @return [nil] nil
    def parse(data)
      # Call parser if header not parsed
      if @parsed
        @body += data
      else
        return nil if data.nil?

        @parser << data
        @body += data[@parser.offset..] if @parsed
      end

      # Set body parsed if body reaches content length
      if @parsed && (@header['Content-Length'].to_i || 0) <= @body.bytesize
        @body_parsed = true
        pre_proceed
      end
      nil
    end

    # Get the real user IP from headers
    # @return [String | nil] nil when not available, otherwise, return the real IP
    # Modified from Rack
    def parse_ip
      # Do not parse anything if not behind proxy
      return nil unless Inori::Configure.proxy
      return @header['X-Real-IP'] if Inori::Configure.trust_real_ip
      # Not enough infomation
      return nil if @header['X-Forwarded-For'].nil?

      forwarded_ips = @header['X-Forwarded-For'].split(', ')
      # Spoofing check
      trusted = forwarded_ips.grep_v(Inori::Configure.trusted_proxies)
      trusted.last
    end

    # Preproceed the request after parsed
    # @return [nil] nil
    def pre_proceed
      # Deal with Websocket
      upgrade = @header['Connection']&.split(', ')&.include?('Upgrade')
      if upgrade && @header['Upgrade'] == 'websocket'
        @method = :WEBSOCKET
        @is_websocket = true
      end

      @method = @method.to_sym
      nil
    end

    # Syntactic sugar for whether a request header is parsed
    # @return [Boolean] parsed or not
    def parsed?
      @parsed
    end

    # Syntactic sugar for whether a request body is parsed
    # @return [Boolean] parsed or not
    def body_parsed?
      @body_parsed
    end

    # Syntactic sugar for whether a request is a websocket request
    # @return [Boolean] websocket or not
    def websocket?
      @is_websocket
    end
  end
end
