require 'playwright/play'
require 'playwright/cli/get'
require 'playwright/cli/new'

module Playwright
  class Cli < Play

    class NoRubyClassError < StandardError; end

    NO_COMMAND_MSG = "$ playwright what?\nYou need to enter a command.".freeze
    INVALID_COMMAND_MSG = "Playwright doesn't know that command.".freeze
    COMMANDS = [
      { klass:'get', terms: ['get'] },
      { klass: 'new', terms: ['generate', 'g', 'new'] }
    ].freeze

    PARAMS_MAP = [:command]
    VALIDATIONS = [
      {
        condition: proc { !params.command },
        message: NO_COMMAND_MSG
      },
      {
        condition: proc { !self.class.terms.include?(params.command) },
        message: INVALID_COMMAND_MSG
      }
    ]

    def run
      params.arguments.length > 1 ? klass.run(params.arguments[1..-1]) : klass.run
    end

    def klass
      Object.const_get("#{self.class}::#{params.command.capitalize}")
    rescue NameError => e
      raise NoRubyClassError, "There's no ruby class for this command!"
    end

    def self.terms
      COMMANDS.map{|com|com[:terms]}.flatten
    end

  end
end
