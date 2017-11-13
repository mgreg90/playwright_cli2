RSpec.describe Playwright::Cli::New do
  let(:args) { defined?(play_name) ? [play_name] : [] }
  let(:subject) { described_class.new(args) }
  before  { MemFs.activate! }
  after   { MemFs.deactivate! }

  describe "#run" do
    let(:method) { :run }
    context "when no play name is given" do
      include_examples "should exit"
      it "should complain to the user" do
        expect{ subject.run }.to output(Playwright::Cli::New::NO_PLAY_NAME_MSG).to_stdout
      end
    end
    context "when a play name is given" do
      let(:play_name) { 'my_play' }
      include_examples "should not exit"
      it "should call #create_executable!" do
        expect(subject).to receive(:create_executable!).with(no_args)
        subject.run
      end
    end
  end
  
  describe "#play_already_exists?" do
    let(:method) { :play_already_exists? }
    let(:play_name) { 'do_things' }
    context "when a play with that name already exists" do
      before { FileUtils.mkdir_p(File.join(Playwright::PLAYS_PATH, play_name)) }
      include_examples "should exit"
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
  
  describe "#create_executable!" do
    let(:method) { :create_executable! }
    let(:play_name) { 'my_play' }
    let(:file) { File.join(Playwright::PLAYS_PATH,  "#{play_name}.rb") }
    include_examples "should not exit"
    it "creates file" do
      subject.send(method)
      expect(File.exists?(file)).to be true
    end
  end
  
  describe "#"

end