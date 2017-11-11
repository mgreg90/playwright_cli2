module Playwright
  class Cli < Play
    class Get

      def self.run
        new.run
      end

      def initialize
        # TODO getting this CLI working!!!
      end

      def run
        puts "Get was called in Playwright::Cli::Get!"
      end

    end
  end
end