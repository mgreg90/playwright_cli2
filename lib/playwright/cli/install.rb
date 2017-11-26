module Playwright
  class Cli < Play
    class Install

      # Builds the following file structure
      # ~/.playwright
      #    |- plays/ # body of each play gets a folder with a file with #{play_name}.rb
      #    |- bin/   # each play gets a single executable file.

      def self.run
        new.run
      end

      def run
        create_file_structure
        add_to_path
        # TODO add ~/.playwright/bin to path
        puts "Installation complete!"
        puts "Please restart your terminal and ..."
        puts "Start a play with:"
        puts "$ playwright new your-play-name"
      end

      def create_file_structure
        find_or_create(Playwright::BIN_PATH)
        find_or_create(Playwright::PLAYS_PATH)
      end

      def find_or_create(dir)
        if Dir.exists?(dir)
          dir_exists_msg(dir)
        else
          FileUtils.mkdir_p(dir)
          dir_created_msg(dir)
        end
      end

      def dir_exists_msg(dir)
        puts "#{dir} already exists!"
      end

      def dir_created_msg(dir)
        puts "#{dir} created!"
      end

      def add_to_path
        puts "Updating $PATH in #{profile}"
        File.open(profile, 'a') do |f|
          f.puts "\n\n# Add Playwright executables to PATH"
          f.puts "export PATH=$PATH:#{Playwright::BIN_PATH}"
        end
      end

      def profile
        require 'pry'; binding.pry
        @profile ||= ['.zshrc', '.bashrc', '.bash_profile', '.profile'].map do |file|
          file = File.join(Dir.home, file)
          File.exists?(file) ? file : nil
        end.compact.first
        raise "No Bash Profile Found!" unless @profile
        puts "Added ~/.playwright/bin to $PATH"
        @profile
      end

    end
  end
end
