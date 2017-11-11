module Playwright
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
      find_or_create(BIN_PATH)
      find_or_create(PLAYS_PATH)
    end

    def find_or_create(dir)
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
