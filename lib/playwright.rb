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
  NEW_TEMPLATE_PATH = File.join(PLAYWRIGHT_GEM_PATH, 'public', 'assets', 'new_play.rb.erb')

  class PlaywrightExit < SystemExit; end

  def self.install
    Cli::Install.run
  end

end