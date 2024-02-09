# frozen_string_literal: true

module Inori
  ##
  # Sandbox for global error capture
  class Sandbox
    class << self
      def class_initialize
        @handlers = {}
        @handlers[Inori::Exception::InternalError] = proc { |e|
          Inori::Response.new(status: 500, body: "#{e.inspect} #{e.backtrace}")
        }
        @handlers[Inori::Exception::NotFound] = proc { |_e| Inori::Response.new(status: 404, body: '404 Not Found') }
      end

      # Add a rule to Sandbox
      # @param [Class] class_name the class to capture
      # @param [Proc] block what to do when captured
      # @return [nil] nil
      def add_rule(class_name, block)
        @handlers[class_name] = block
        nil
      end

      # Detect what to run with given error
      # @param [StandardError] error the error captured
      # @return [nil] nil
      def capture(error)
        if @handlers[error.class].nil?
          @handlers[Inori::Exception::InternalError].call(error)
        else
          @handlers[error.class].call(error)
        end
      end

      # Run sandbox inside given clean room
      # @param [Inori::CleanRoom] clean_room Clean room to run
      # @param [Proc] function the block to run
      # @return [nil] nil
      def run(clean_room, function, *args)
        function.to_lambda(clean_room).call(*args)
      rescue StandardError => e
        capture(e)
      end
    end

    private_class_method :class_initialize
    class_initialize
  end
end
