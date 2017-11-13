module Playwright
  class Cli < Play
    class New < Play

      NO_PLAY_NAME_MSG = "You need to give your play a name!"
      PLAY_ALREADY_EXISTS_MSG = "You need to give your play a name!"

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

      def run
        # create executable file just called "#{play_name}"
        create_executable!
        # create gemfile
        # create config.yml
        # create lib/"#{play_name}".rb
        # bundle
        # open editor
      end

      def play_already_exists?
        File.exists?(File.join(PLAYS_PATH, params.play_name))
      end

      def create_executable!
        FileUtils.mkdir_p(PLAYS_PATH)
        file_name = File.join(PLAYS_PATH, "#{params.play_name}.rb")
        File.open(file_name, "w+") do |file|
          file << "#!/usr/bin/env ruby"
          file << "\n"
          # file << 
        end
      end

    end
  end
end