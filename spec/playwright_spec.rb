RSpec.describe Playwright do
  it "has a version number" do
    expect(Playwright::VERSION).not_to be nil
  end

  describe '#install' do
    it "calls Playwright::Cli::Installer.run" do
      expect(Playwright::Cli::Install).to receive(:run).with(no_args)
      Playwright.install
    end
  end
end
