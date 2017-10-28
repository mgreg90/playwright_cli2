require "playwright/version"
require "playwright/commands/installer.rb"

module Playwright

  def self.install
    Commands::Installer.run
  end

end
