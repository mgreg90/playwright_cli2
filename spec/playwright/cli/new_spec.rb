RSpec.describe Playwright::Cli::New do
  let(:args) { defined?(play_name) ? [play_name] : [] }
  let(:subject) { described_class.new(args) }
  before do
    MemFs.activate!
    Playwright.install
    allow(subject).to receive(:play_body_contents).and_return('')
  end
  after { MemFs.deactivate! }

  describe "#run" do
    let(:method) { :run }
    context "when no play name is given" do
      include_examples "should exit"
      it "should complain to the user" do
        expect{ subject.run }.to output(Playwright::Cli::New::NO_PLAY_NAME_MSG).to_stdout
      end
    end
    context "when a play name is given" do
      before { class MyPlay; end }
      let(:play_name) { 'my_play' }
      include_examples "should not exit"
    end
  end

  describe "#play_already_exists?" do
    let(:method) { :play_already_exists? }
    let(:play_name) { 'do_things' }
    context "when a play with that name already exists" do
      before do
        FileUtils.mkdir_p(Playwright::BIN_PATH)
        FileUtils.touch(File.join(Playwright::BIN_PATH, 'do-things'))
      end
      include_examples "should not exit"
      it "should return true" do
        expect(subject.play_already_exists?).to be true
      end
    end
    context "when a play with that name does not exist" do
      include_examples "should not exit"
      it "should return false" do
        expect(subject.play_already_exists?).to be false
      end
    end
  end

  describe "#create_executable" do
    let(:method) { :create_executable }
    let(:play_name) { 'my_play' }
    let(:file) { File.join(Playwright::BIN_PATH, "my-play") }
    include_examples "should not exit"
    it "creates file" do
      subject.send(method)
      expect(File.exists?(file)).to be true
    end
  end

  describe "#create_gemfile" do
    let(:method) { :create_gemfile }
    let(:play_name) { 'my_play' }
    let(:file) { File.join(Playwright::PLAYS_PATH, "my_play", "Gemfile") }
    include_examples "should not exit"
    it "creates file" do
      subject.send(method)
      expect(File.exists?(file)).to be true
    end
  end

  describe "#create_config" do
    let(:method) { :create_config }
    let(:play_name) { 'my_play' }
    let(:file) { File.join(Playwright::PLAYS_PATH, "my_play", "config.yml") }
    include_examples "should not exit"
    it "creates file" do
      subject.send(method)
      expect(File.exists?(file)).to be true
    end
  end

  describe "#create_play_body" do
    let(:method) { :create_play_body }
    let(:play_name) { 'my_play' }
    let(:file) { File.join(Playwright::PLAYS_PATH, "my_play", "my_play.rb") }
    include_examples "should not exit"
    it "creates file" do
      subject.send(method)
      expect(File.exists?(file)).to be true
    end
  end

  describe "#play_body_contents" do
    before do
      MemFs.deactivate!
      Playwright.install
      allow(subject).to receive(:play_body_contents).and_call_original
    end
    after { MemFs.activate! }
    let(:method) { :play_body_contents }
    let(:play_name) { 'my_play' }
    let(:first_line) { subject.send(method).split("\n").first }
    it "should inherit from Playwright::Play" do
      expect(first_line).to match(/Playwright::Play$/)
    end
    it "should not include dummy text" do
      expect(first_line).not_to match(/\*\*play_name\*\*/)
    end
  end

  describe "#create_lib" do
    let(:method) { :create_lib }
    let(:play_name) { 'my_play' }
    let(:directory) { File.join(Playwright::PLAYS_PATH, "my_play", "lib") }
    include_examples "should not exit"
    it "creates directory" do
      subject.send(method)
      expect(Dir.exists?(directory)).to be true
    end
  end

end