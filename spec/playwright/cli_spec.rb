RSpec.describe Playwright::Cli do
  let(:args) { [] }
  let(:subject) { described_class.new(args) }
  describe "#run" do
    context "when no command is given" do
      it "should complain to the user" do
        begin
          expect{ subject.run }.to output(Playwright::Cli::NO_COMMAND_MSG).to_stdout
        rescue SystemExit
        end
      end
      it "should exit" do
        begin
          expect{ subject.run }.to raise_error(SystemExit)
        rescue SystemExit
        end
      end
    end

    context "when the command is 'get'" do
      let(:args) { ['get'] }
      it "calls Playwright::Cli::Get.run" do
        expect(Playwright::Cli::Get).to receive(:run)
        subject.run
      end
    end

    context "when the command is nonsense" do
      let(:args) { ['asgdab'] }
      it "should complain to the user" do
        begin
          expect{ subject.run }.to output(Playwright::Cli::INVALID_COMMAND_MSG).to_stdout
        rescue SystemExit
        end
      end
      it "should exit" do
        begin
          expect{ subject.run }.to raise_error(SystemExit)
        rescue SystemExit
        end
      end
    end

  end
end
