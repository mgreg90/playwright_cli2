module Playwright
  class Cli < Play
    class New < Play

      attr_reader :play_name, :directories

      NO_PLAY_NAME_MSG = "You need to give your play a name!".freeze
      PLAY_ALREADY_EXISTS_MSG = "That play name is already taken!".freeze

      map_params :play_name

      map_option short: 's', long: 'service', require_value: true

      validate proc { !params.play_name },
        NO_PLAY_NAME_MSG
      validate proc { play_already_exists? },
        PLAY_ALREADY_EXISTS_MSG

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
        open_editor
      end

      def play_already_exists?
        File.exists?(directories.executable_file_name_and_path)
      end

      def create_executable
        FileUtils.mkdir_p(directories.executable_filepath)
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
        FileUtils.mkdir_p(directories.play_body_filepath)
        File.open(directories.gemfile_name_and_path, "w+") do |file|
          file << gemfile_contents
        end
        puts "Gemfile Created!"
      end

      def gemfile_contents
        <<~GEMFILE_CONTENTS
          source 'https://rubygems.org'
          ruby '2.4.1'

          gem 'playwright_cli', git: 'https://github.com/mgreg90/playwright_cli.git', branch: 'develop', require: 'playwright'
          gem 'httparty'

          group :development do
            gem 'pry'
          end
        GEMFILE_CONTENTS
      end

      def create_config
        FileUtils.mkdir_p(directories.play_body_filepath)
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
        FileUtils.mkdir_p(directories.play_body_filepath)
        File.open(directories.play_body_file_name_and_path, "w+") do |file|
          file << play_body_contents
        end
        puts "Play file Created!"
      end

      def play_body_contents
        @play_body_contents ||= begin
          template = File.read(NEW_TEMPLATE_PATH)
          prepare_new_play(template)
        end
      end

      def prepare_new_play(template)
        vars = {play_name: play_name.to_pascal_case}
        generic_api_url = "http://jsonplaceholder.typicode.com/posts"
        service_line = if params.service
          vars[:service?] = true
          "set_service \"#{params.service}\""
        else
          vars[:service?] = false
          "# set_service \"#{generic_api_url}\""
        end
        vars[:service_line] = service_line
        Renderer.render(template, vars)
      end

      def create_lib
        FileUtils.mkdir_p(File.join(directories.play_body_filepath, 'lib'))
        puts "Lib directory Created!"
      end

      def bundle
        result = `cur_dir="$(pwd)" &&
        cd #{directories.play_body_filepath} &&
        ls -al &&
        pwd &&
        bundle --gemfile="#{directories.gemfile_name_and_path}" &&
        cd $cur_dir`
        if result.match(/Bundle complete!/)
          puts "Play bundled!"
        else
          puts "Bundle failed!"
        end
      end

      def git_init
        lines = `cur_dir="$(pwd)" &&
        cd #{directories.play_body_filepath} &&
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
        visual = `echo $VISUAL`
        if visual && visual != ''
          `$VISUAL #{directories.play_body_filepath}`
        else
          `$EDITOR #{directories.play_body_filepath}`
        end
      end

    end
  end
end