module Playwright
  class Play
    class Display

      def self.show(opts={})
        new(opts).show
      end

      def initialize(opts={})
        @json = opts[:json]
      end

      def show
        puts JSON.pretty_generate @json if @json
      end

    end
  end
end