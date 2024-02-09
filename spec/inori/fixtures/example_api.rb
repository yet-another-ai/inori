# frozen_string_literal: true

module Inori
  class Configure
    set :logger, Logger.new(StringIO.new)
    set :bind, '127.0.0.1'
    set :port, 8080
    set :keep_alive_timeout, 3
    set :keep_alive_requests, 3
    set :socket_reuse_port, true
  end
end

class User < Inori::API
  get '/' do
    'User'
  end
end

class ExampleMiddleware < Inori::Middleware
  helper :test_helper_inside_middleware do
    'Hello World'
  end
end

class ExampleAPI < Inori::API
  helper :test_helper do
    'Hello World'
  end

  mount '/user', User
  use ExampleMiddleware

  filter ExampleMiddleware
  get '/' do
    return test_helper
  end

  get '/2' do
    test_helper_inside_middleware
  end

  get '/hello' do
    "Hello\n"
  end

  get '/error' do
    raise StandardError
  end

  get '/large' do
    'w' * (2**20)
  end

  get '/stop' do
    EXAMPLE_RUNNER.stop
  end

  define_error :test_error
  capture TestError do |_e|
    'Hello Error'
  end

  get '/test_error' do
    raise TestError
  end

  websocket '/websocket' do |ws|
    ws.on :open do
      ws.send ws.connection.request.query_params['param'][0]
    end

    ws.on :message do |msg|
      ws.send msg
    end

    ws.on :pong do
      ws.send ''
    end

    ws.on :close do
    end
  end

  websocket '/websocket/opcode' do |ws|
    ws.on :open do
      ws.send Object.new
    end
  end

  websocket '/websocket/ping' do |ws|
    ws.on :open do
      ws.ping ''
    end
  end

  websocket '/websocket/too_large_ping' do |ws|
    ws.on :message do
      ws.ping '01234567890123456789012345678901
      23456789012345678901234567890123456789012
      34567890123456789012345678901234567890123
      45678901234567890123456789012345678901234
      56789012345678901234567890123456789012345
      67890123456789012345678901234567890123456
      78901234567890123456789012345678901234567
      89012345678901234567890123456789012345678
      90123456789012345678901234567890123456789
      012345678901234567890123456789'
    end
  end

  websocket '/websocket/wrong_opcode' do |ws|
  end

  eventsource '/eventsource' do |es|
    es.send("Hello\nWorld")
  end
end

EXAMPLE_API_ENGINE = Inori::APIEngine.new(ExampleAPI)
EXAMPLE_RUNNER = Inori::Runner.new(EXAMPLE_API_ENGINE)
