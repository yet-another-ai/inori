# frozen_string_literal: true

require './spec/spec_helper'
require 'socket'

RSpec.describe Inori::Server do
  runner = EXAMPLE_RUNNER

  before(:all) do
    Thread.new { runner.start }
    sleep 1
  end

  describe 'Basic Requests' do
    it 'returns Hello World on GET / request' do
      Timeout.timeout(1) do
        expect(Typhoeus.get('http://127.0.0.1:8080/').body).to eq('Hello World')
      end
    end

    it 'could deal with very large response' do
      Timeout.timeout(10) do
        expect(Typhoeus.get('http://127.0.0.1:8080/large').body.bytesize).to eq(('w' * (2**20)).bytesize)
      end
    end

    it 'could generate body size correctly' do
      Timeout.timeout(10) do
        expect(Typhoeus.get('http://127.0.0.1:8080/large').headers['Content-Length'].to_i).to eq(('w' * (2**20)).bytesize)
      end
    end

    it 'returns Hello World on GET /2 request' do
      Timeout.timeout(1) do
        expect(Typhoeus.get('http://127.0.0.1:8080/2').body).to eq('Hello World')
      end
    end

    it 'returns 404 Not Found on GET /not_found_error' do
      Timeout.timeout(1) do
        expect(Typhoeus.get('http://127.0.0.1:8080/not_found_error').code).to eq(404)
      end
    end

    it 'returns 500 Internal Server Error on GET /error' do
      Timeout.timeout(1) do
        expect(Typhoeus.get('http://127.0.0.1:8080/error').code).to eq(500)
      end
    end

    it 'passes test error definition' do
      Timeout.timeout(1) do
        expect(Typhoeus.get('http://127.0.0.1:8080/test_error').body).to eq('Hello Error')
      end
    end
  end

  describe 'keep-alive' do
    it 'does not close the socket with first request' do
      Timeout.timeout(1) do
        socket.print "GET /hello HTTP/1.1\r\n\r\n"
        Array.new(5) { socket.gets }
        socket.print "GET /hello HTTP/1.1\r\n\r\n"
        expect(socket.closed?).to be(false)
        socket.close
      end
    end

    it 'closes the socket after the third request' do
      Timeout.timeout(1) do
        3.times do
          socket.print "GET /hello HTTP/1.1\r\n\r\n"
          Array.new(5) { socket.gets }
        end
        expect do
          socket.print "GET /hello HTTP/1.1\r\n\r\n"
          raise Errno::ECONNRESET if socket.read(16_364).nil?
        end.to raise_error(Errno::ECONNRESET)
        socket.close
      end
    end

    it 'closes the socket after 3 seconds' do
      Timeout.timeout(10) do
        socket.print "GET /hello HTTP/1.1\r\n\r\n"
        Array.new(5) { socket.gets }
        sleep 4
        # Connection should closed, check coverage for details
      end
    end
  end

  describe 'Websocket' do
    let(:socket) { TCPSocket.new '127.0.0.1', 8080 }

    it 'pass example websocket communication' do
      Timeout.timeout(1) do
        socket.print "GET /websocket?param=Hello HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        # Receive 'Hello' on Open
        result = Array.new(7) { socket.getbyte }
        expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
        # Receive 'Hello' after sending 'Hello'
        socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        result = Array.new(7) { socket.getbyte }
        expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
        # Receive 'Hello' pong after sending 'Hello' ping
        socket.print [0x89, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        result = Array.new(7) { socket.getbyte }
        expect(result).to eq([0x8a, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
        # Receive [1, 2, 3] after sending [1, 2, 3]
        socket.print [0x82, 0x83, 0xac, 0xfe, 0x1a, 0x97, 0xad, 0xfc, 0x19].pack('C*')
        result = Array.new(5) { socket.getbyte }
        expect(result).to eq([0x82, 0x3, 0x1, 0x2, 0x3])
        # Try send pong 'Hello'
        socket.print [0x8a, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        result = Array.new(2) { socket.getbyte }
        expect(result).to eq([0x81, 0x0])
        # Expect Websocket close
        socket.print [0x88].pack('C*')
        result = socket.getbyte
        expect(result).to eq(0x8)
        socket.close
      end
    end

    it 'passes keep-alive websocket upgrade' do
      Timeout.timeout(1) do
        socket.print "GET /websocket?param=Hello HTTP/1.1\r\nHost: localhost:8080\r\nConnection: keep-alive, Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        # Receive 'Hello' on Open
        result = Array.new(7) { socket.getbyte }
        expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
        socket.close
      end
    end

    it 'raise error when sending unsupported OpCode' do
      Timeout.timeout(1) do
        socket.print "GET /websocket/opcode HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        # Connection lost
        socket.close
      end
    end

    it 'pings' do
      Timeout.timeout(1) do
        socket.print "GET /websocket/ping HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        result = Array.new(2) { socket.getbyte }
        expect(result).to eq([0x89, 0x0])
        socket.close
      end
    end

    it 'send too large ping' do
      Timeout.timeout(1) do
        socket.print "GET /websocket/too_large_ping HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        result = socket.getbyte
        expect(result).to eq(0x8)
        socket.close
      end
    end

    it 'wrong opcode' do
      Timeout.timeout(1) do
        socket.print "GET /websocket/wrong_opcode HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-Websocket-Version: 13\r\nSec-Websocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) { socket.gets }
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-Websocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        socket.print [0x83, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        socket.close
      end
    end
  end

  # TODO: Reimplement the EventSource test
  # describe 'EventSource' do
  #   it 'should pass Hello World test' do
  #     Timeout::timeout(1) do
  #       expect(Typhoeus.get("http://127.0.0.1:8080/eventsource", headers: {
  #           'Accept' => 'text/event-stream'
  #       }).body).to eq("data: Hello\ndata: World\n\n")
  #     end
  #   end
  # end
end
