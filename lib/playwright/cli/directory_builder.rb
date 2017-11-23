module Playwright
  class DirectoryBuilder

    attr_reader :play_name

    def initialize(play_name)
      @play_name = play_name
    end

    def executable_file_path
      BIN_PATH
    end

    def executable_file_name
      play_name.to_dash_case
    end

    def executable_file_name_and_path
      File.join(executable_file_path, executable_file_name)
    end

    def play_body_file_path
      File.join(PLAYS_PATH, play_name.to_snake_case)
    end

    def play_body_file_name
      "#{play_name.to_snake_case}.rb"
    end

    def play_body_file_name_and_path
      File.join(play_body_file_path, play_body_file_name)
    end

    def gemfile_name_and_path
      File.join(play_body_file_path, "Gemfile")
    end

    def config_name_and_path
      File.join(play_body_file_path, "config.yml")
    end

    def play_class
      play_name.to_pascal_case
    end

  end
end