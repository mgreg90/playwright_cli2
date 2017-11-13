RSpec.describe Playwright::Cli do
  let(:args) { [] }
  let(:subject) { described_class.new(args) }

  describe "#run" do
    let(:method) { :run }
    context "when no command is given" do
      include_examples "should exit"
      it "should complain to the user" do
        expect{ subject.run }.to output(Playwright::Cli::NO_COMMAND_MSG).to_stdout
      end
    end

    context "when the command is 'get'" do
      let(:args) { ['get'] }
      include_examples "should not exit"
      it "calls Playwright::Cli::Get.run" do
        expect(Playwright::Cli::Get).to receive(:run)
        subject.run
      end
    end

    context "when the command is nonsense" do
      let(:args) { ['asgdab'] }
      it "should complain to the user" do
          expect{ subject.run }.to output(Playwright::Cli::INVALID_COMMAND_MSG).to_stdout
      end
      include_examples "should exit"
    end

  end

  describe "#klass" do
    let(:method) { :klass }
    context "when params.command is the name of a ruby class" do
      let(:args) { ['get'] }
      it "should return that class" do
        expect(subject.klass).to eq(Playwright::Cli::Get)
      end
    end

    context "when params.command is not the name of a ruby class" do
      let(:args) { ['somebullshit'] }
      it "should raise a NoRubyClassError" do
          allow(Playwright::Cli).to receive(:terms).and_return(['somebullshit'])
          expect{subject.klass}.to raise_error(Playwright::Cli::NoRubyClassError)
      end
    end
  end

  describe "#terms" do
    let(:method) { :terms }
    let(:subject) { described_class }
    let(:commands) do
      [
        { klass: 'junk', terms: ['junk', 'garbage', 'nonsense']},
        { klass: 'good', terms: ['yay', 'good']},
        { klass: 'clock', terms: ['clock']}
      ]
    end
    include_examples "should not exit"
    it "should return a flat array of all the terms in the command constant" do
      stub_const("Playwright::Cli::COMMANDS", commands)
      result = ['junk', 'garbage', 'nonsense', 'yay', 'good', 'clock']
      expect(subject.terms).to eq(result)
    end
  end
end
