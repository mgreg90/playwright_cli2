module Playwright
  class Play
    class Service
      class Request

        attr_reader :httparty_response

        def self.get(*args, &block)
          new(:get, *args, &block)
        end

        def self.post(*args, &block)
          new(:post, *args, &block)
        end

        def initialize(method, *args, &block)
          @errors = []
          begin
            args = args.select{|arg| (arg.is_a? String) || arg.any? }
            @httparty_response = HTTParty.send(method, *args)
          rescue SocketError
            @errors << :socket_error
          end
        end

        def success
          yield(response, status) if success?
          self
        end

        def failure
          yield(response, status) if failure?
          self
        end

        def always
          yield(response, status)
          self
        end

        def failure?
          @errors.any? || httparty_response && !httparty_response.success?
        end

        def success?
          !failure?
        end

        def response
          @httparty_response.parsed_response
        end

        def status
          @httparty_response.code
        end

      end
    end
  end
end