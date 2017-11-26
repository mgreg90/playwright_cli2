RSpec.describe Playwright::Cli::Install do
  before  { MemFs.activate! }
  after   { MemFs.deactivate! }

  describe '#create_file_structure' do

    it "creates bin folder" do
      subject.create_file_structure
      expect(Dir.exists?("#{Dir.home}/.playwright/bin")).to be true
    end

    it "creates plays folder" do
      subject.create_file_structure
      expect(Dir.exists?("#{Dir.home}/.playwright/plays")).to be true
    end

  end

  describe '#find_or_create' do
    let(:bin_path) { Playwright.const_get('BIN_PATH') }
    context "when directory doesn't exist" do
      it 'outputs created msg' do
        expect { subject.find_or_create(bin_path) }.to output("#{bin_path} created!\n").to_stdout
      end
      it 'creates the file' do
        subject.find_or_create(bin_path)
        expect(Dir.exists?(bin_path)).to be true
      end
    end
    context "when directory already exists" do
      before { FileUtils.mkpath(bin_path) }
      it 'outputs created msg' do
        expect { subject.find_or_create(bin_path) }.to output("#{bin_path} already exists!\n").to_stdout
      end
    end
  end

  describe "#profile" do
    context "when .zshrc exists" do
      let(:file) { File.join(Dir.home, '.zshrc') }
      before do
        FileUtils.mkdir_p(Dir.home)
        FileUtils.touch(file)
      end
      it "returns the path to .zshrc" do
        expect(subject.profile).to eq(file)
      end
    end

    context "when only .profile exists" do
      let(:file) { File.join(Dir.home, '.profile') }
      before do
        FileUtils.mkdir_p(Dir.home)
        FileUtils.touch(file)
      end
      it "returns the path to .profile" do
        expect(subject.profile).to eq(file)
      end
    end

    context "when .bash_profile and .bashrc exist" do
      let(:bashrc) { File.join(Dir.home, '.bashrc') }
      let(:bash_profile) { File.join(Dir.home, '.bash_profile') }
      before do
        FileUtils.mkdir_p(Dir.home)
        FileUtils.touch(bashrc)
        FileUtils.touch(bash_profile)
      end
      it "returns the path to .bashrc" do
        expect(subject.profile).to eq(bashrc)
      end
    end
  end

  describe "#add_to_path" do
    let(:file) { File.join(Dir.home, '.made_up') }
    before do
      allow(subject).to receive(:profile).and_return(file)
      FileUtils.mkdir_p(Dir.home)
    end
    it "should write to file" do
      subject.add_to_path
      contents = File.read(file).strip.split("\n")
      expect(contents.length).to eq 2
    end
  end
end
