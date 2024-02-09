# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Inori::Request do
  it 'parse request without query_string' do
    data = "GET / HTTP/1.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.protocol).to eq('1.1')
    expect(request.method).to eq(:GET)
    expect(request.path).to eq('/')
    expect(request.query_string).to be_nil
    expect(request.query_params).to eq({})
  end

  it 'parse request with query_string' do
    data = "GET /?test=1 HTTP/1.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.protocol).to eq('1.1')
    expect(request.method).to eq(:GET)
    expect(request.path).to eq('/')
    expect(request.query_string).to eq('test=1')
    expect(request.query_params['test']).to eq(['1'])
  end

  it 'parse request with cookies' do
    data = "GET /?test=1 HTTP/1.1\r\nCookie: a=1; b=2\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.protocol).to eq('1.1')
    expect(request.method).to eq(:GET)
    expect(request.path).to eq('/')
    expect(request.cookie['a'].name).to eq('a')
    expect(request.cookie['a'].value).to eq(['1'])
    expect(request.cookie['b'].value).to eq(['2'])
  end

  it 'ignore real IP when not available' do
    Inori::Configure.proxy = false
    data = "GET /?test=1 HTTP/1.1\r\nX-Real-IP: 1.2.3.4\r\nX-Forwarded-For: 1.2.3.4, 127.0.0.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.ip).to be_nil
    expect(request.remote_ip).to be_nil
  end

  it 'parse real IP behind proxy' do
    Inori::Configure.proxy = true
    data = "GET /?test=1 HTTP/1.1\r\nX-Real-IP: 1.2.3.4\r\nX-Forwarded-For: 1.2.3.4, 127.0.0.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.ip).to be_nil
    expect(request.remote_ip).to eq('1.2.3.4')
  end

  it 'ignore real IP when spoofing' do
    Inori::Configure.proxy = true
    data = "GET /?test=1 HTTP/1.1\r\nX-Real-IP: 1.2.3.4\r\nX-Forwarded-For: 1.2.3.4, 13.0.0.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.ip).to be_nil
    expect(request.remote_ip).to eq('13.0.0.1')
  end

  it 'trust real IP' do
    Inori::Configure.proxy = true
    Inori::Configure.trust_real_ip = true
    data = "GET /?test=1 HTTP/1.1\r\nX-Real-IP: 1.2.3.4\r\nX-Forwarded-For: 1.2.3.4, 13.0.0.1\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.ip).to be_nil
    expect(request.remote_ip).to eq('1.2.3.4')
  end

  it 'parse request with header and body' do
    data = "GET / HTTP/1.1\r\nTest: Hello\r\n\r\nBody"
    request = described_class.new
    request.parse(data)
    expect(request.header['Test']).to eq('Hello')
    expect(request.body).to eq('Body')
  end

  it 'parse request with separated body' do
    data = "GET / HTTP/1.1\r\nContent-Length: 4\r\n\r\n"
    request = described_class.new
    request.parse(data)
    request.parse('Body')
    expect(request.body).to eq('Body')
  end

  it 'parse websocket upgrade' do
    data = "GET / HTTP/1.1\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.method).to eq(:WEBSOCKET)
  end

  it 'parse eventsource upgrade' do
    data = "GET / HTTP/1.1\r\nAccept: text/event-stream\r\n\r\n"
    request = described_class.new
    request.parse(data)
    expect(request.method).to eq(:EVENTSOURCE)
  end

  it 'parses all methods' do
    methods = %w[ delete
                  get
                  head
                  post
                  put
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
                  m-search
                  notify
                  subscribe
                  unsubscribe
                  link
                  unlink
                  patch
                  purge].freeze

    methods.each do |method|
      request = described_class.new
      data = "#{method.upcase} / HTTP/1.1\r\n\r\n"
      request.parse(data)
      expect(request.method).to eq(method.upcase.to_sym)
    end
  end
end
