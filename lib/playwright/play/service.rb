module Playwright
  class Play
    class Service

      attr_reader :base_url

      def initialize(base_url)
        @base_url = base_url
      end

      def get
        HTTParty.get(base_url).parsed_response
      end

    end
  end
end