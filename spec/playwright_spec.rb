RSpec.describe Playwright do
  it "has a version number" do
    expect(Playwright::VERSION).not_to be nil
  end

  describe '#install' do    
    it "calls Playwright::Commands::Installer.run" do
      expect(Playwright::Commands::Installer).to receive(:run).with(no_args)
      Playwright.install
    end
  end
end
