# require_relative "playwright/utils/arguments.rb"
# require_relative "playwright/utils/params.rb"
#
# require_relative "playwright/cli.rb"
# require_relative "playwright/installer.b"
# require_relative "playwright/play.rb"
# require_relative "playwright/version.rb"

require 'fileutils'
require 'httparty'

require 'ext/string'

require 'playwright/version'
require 'playwright/play'
require 'playwright/cli'

module Playwright

  PLAYWRIGHT_GEM_PATH = File.expand_path('..', __dir__)
  PLAYWRIGHT_PATH = File.join(Dir.home, ".playwright").freeze
  BIN_PATH = File.join(PLAYWRIGHT_PATH, "bin").freeze
  PLAYS_PATH = File.join(PLAYWRIGHT_PATH, "plays").freeze

  class PlaywrightExit < SystemExit; end

  def self.install
    Cli::Install.run
  end

end