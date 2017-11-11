require 'playwright/play'
require 'playwright/cli/get'

module Playwright
  class Cli < Play

    NO_COMMAND_MSG = "$ playwright what?\nYou need to enter a command.".freeze
    INVALID_COMMAND_MSG = "Playwright doesn't know that command.".freeze
    COMMANDS = ['get'].freeze

    PARAMS_MAP = [:command]
    VALIDATIONS = [
      {
        condition: proc { !params.command },
        message: NO_COMMAND_MSG
      },
      {
        condition: proc { !COMMANDS.include?(params.command) },
        message: INVALID_COMMAND_MSG
      }
    ]

    def run
      Object.const_get("#{self.class}::#{params.command.capitalize}").run
    end

  end
end
