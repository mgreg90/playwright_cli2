RSpec.describe Playwright::DirectoryBuilder do
  let(:play_name) { "my_example_play" }
  let(:subject) { described_class.new(play_name) }

  describe "#executable_filepath" do
    it "should be 'Playwright::BIN_PATH'" do
      expect(subject.executable_filepath).to eq Playwright::BIN_PATH
    end
  end
  describe "#executable_file_name" do
    it "should be 'my-example-play'" do
      expect(subject.executable_file_name).to eq "my-example-play"
    end
  end
  describe "#executable_file_name_and_path" do
    it "should be 'Playwright::BIN_PATH/my-example-play'" do
      expect(subject.executable_filepath).to eq Playwright::BIN_PATH
    end
  end
  describe "#play_body_filepath" do
    it "should be 'Playwright::PLAYS_PATH/my_example_play'" do
      path = File.join(Playwright::PLAYS_PATH, 'my_example_play')
      expect(subject.play_body_filepath).to eq path
    end
  end
  describe "#play_body_file_name" do
    it "should be 'my_example_play.rb'" do
      expect(subject.play_body_file_name).to eq "my_example_play.rb"
    end
  end
  describe "#play_body_file_name_and_path" do
    it "should be 'Playwright::BIN_PATH/my_example_play/my_example_play.rb'" do
      name_and_path = File.join(Playwright::PLAYS_PATH, 'my_example_play', 'my_example_play.rb')
      expect(subject.play_body_file_name_and_path).to eq name_and_path
    end
  end
  describe "#gemfile_name_and_path" do
    it "should be 'Playwright::BIN_PATH/my_example_play/Gemfile'" do
      name_and_path = File.join(Playwright::PLAYS_PATH, 'my_example_play', 'Gemfile')
      expect(subject.gemfile_name_and_path).to eq name_and_path
    end
  end
  describe "#config_name_and_path" do
    it "should be 'Playwright::BIN_PATH/my_example_play/config.yml'" do
      name_and_path = File.join(Playwright::PLAYS_PATH, 'my_example_play', 'config.yml')
      expect(subject.config_name_and_path).to eq name_and_path
    end
  end
end