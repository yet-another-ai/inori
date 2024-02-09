# frozen_string_literal: true

require './spec/spec_helper'
require 'json'

class User < Inori::API
  get '/' do
    'User'
  end
end

class RawHello < Inori::API
  mount '/user', User
  use Inori::Middleware
  get '/' do
    'Hello'
  end
  post '/' do
  end
  put '/' do
  end
  delete '/' do
  end
  options '/' do
  end
  link '/' do
  end
  unlink '/' do
  end
  msearch '/' do
  end
  websocket '/' do
  end
  eventsource '/' do
  end
end

class JSONMiddleware < Inori::Middleware
  def before(request)
    request.body = JSON.parse(request.body) unless request.body == ''
    request
  end

  def after(_request, response)
    response.header['Content-Type'] = 'application/json'
    response.body = response.body.to_json
    response
  end
end

class JSONHello < Inori::API
  use Inori::Middleware
  filter JSONMiddleware
  get '/' do
    @body = { code: 0 }
  end
end
