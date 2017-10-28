module Playwright
  module Commands
    class Installer

      BIN_PATH = "#{Dir.home}/.playwright/bin".freeze
      PLAYS_PATH = "#{Dir.home}/.playwright/plays".freeze

      def self.run
        new.run
      end

      def run
        create_file_structure
      end

      def create_file_structure
        create_if_exists(BIN_PATH)
        create_if_exists(PLAYS_PATH)
      end

      def create_if_exists(dir)
        if Dir.exists?(dir)
          dir_exists_msg(dir)
        else
          FileUtils.mkpath(dir)
          dir_created_msg(dir)
        end
      end

      def dir_exists_msg(dir)
        puts "#{dir} already exists!"
      end

      def dir_created_msg(dir)
        puts "#{dir} created!"
      end
    end
  end
end