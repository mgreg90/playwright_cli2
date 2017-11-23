module Playwright
  class Cli < Play
    class New < Play

      attr_reader :play_name, :directories

      NO_PLAY_NAME_MSG = "You need to give your play a name!"
      PLAY_ALREADY_EXISTS_MSG = "That play name is already taken!"

      PARAMS_MAP = ['play_name']
      VALIDATIONS = [
        {
          condition: proc { !params.play_name },
          message: NO_PLAY_NAME_MSG
        },
        {
          condition: proc { play_already_exists? },
          message: PLAY_ALREADY_EXISTS_MSG
        }
      ]

      def before_validation
        @play_name = params.play_name
        @directories = DirectoryBuilder.new(@play_name)
      end

      def run
        # create executable file just called "#{play_name}"
        create_executable
        chmod_executable
        create_gemfile
        create_config
        create_play_body
        create_lib
        bundle
        git_init
        # TODO: Add service if option given
        open_editor
      end

      def play_already_exists?
        File.exists?(directories.executable_file_name_and_path)
      end

      def create_executable
        FileUtils.mkdir_p(directories.executable_file_path)
        File.open(directories.executable_file_name_and_path, "w+") do |file|
          file << executable_contents
        end
        puts "Executable Created!"
      end

      def executable_contents
        <<~FILE_CONTENTS
          #!/usr/bin/env ruby

          require "#{directories.play_body_file_name_and_path}"
          #{directories.play_class}.run(ARGV)
        FILE_CONTENTS
      end

      def chmod_executable
        FileUtils.chmod("+x", directories.executable_file_name_and_path)
      end

      def create_gemfile
        FileUtils.mkdir_p(directories.play_body_file_path)
        File.open(directories.gemfile_name_and_path, "w+") do |file|
          file << gemfile_contents
        end
        puts "Gemfile Created!"
      end

      def gemfile_contents
        <<~GEMFILE_CONTENTS
          source 'https://rubygems.org'
          ruby '2.4.1'

          gem 'playwright_cli', git: 'https://github.com/mgreg90/playwright_cli.git', branch: 'cli-new'
        GEMFILE_CONTENTS
      end

      def create_config
        FileUtils.mkdir_p(directories.play_body_file_path)
        File.open(directories.config_name_and_path, "w+") do |file|
          file << config_contents
        end
        puts "Config file Created!"
      end

      def config_contents
        <<~CONFIG_CONTENTS
          version: 0.0.0
        CONFIG_CONTENTS
      end

      def create_play_body
        FileUtils.mkdir_p(directories.play_body_file_path)
        File.open(directories.play_body_file_name_and_path, "w+") do |file|
          file << play_body_contents
        end
        puts "Play file Created!"
      end

      def play_body_contents
        @play_body_contents ||= begin
          template = File.join(PLAYWRIGHT_GEM_PATH, 'public', 'assets', 'new_play.rb.template')
          File.read(template).gsub('**play_name**', play_name.to_pascal_case)
        end
      end

      def create_lib
        FileUtils.mkdir_p(File.join(directories.play_body_file_path, 'lib'))
        puts "Lib directory Created!"
      end

      def bundle
        lines = `cur_dir="$(pwd)" &&
        cd #{directories.play_body_file_path} &&
        ls -al &&
        pwd &&
        bundle --gemfile="#{directories.gemfile_name_and_path}" &&
        cd $cur_dir`
        if lines.match(/Bundle complete!/)
          puts "Play bundled!"
        else
          puts "Bundle failed!"
        end
      end

      def git_init
        lines = `cur_dir="$(pwd)" &&
        cd #{directories.play_body_file_path} &&
        ls -al &&
        pwd &&
        git init &&
        cd $cur_dir`
        if lines.match(/Initialized empty Git repository/)
          puts "Git init'd!"
        else
          puts "Git init failed!"
        end
      end

      def open_editor
        # TODO: linux support
        visual = `echo $VISUAL`
        `open $VISUAL` && return if visual && visual != ''
        `open $EDITOR`
      end

    end
  end
end