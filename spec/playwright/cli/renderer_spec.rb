RSpec.describe Playwright::Cli::Renderer do
  let(:template) { "" }
  let(:var_hash) { {} }
  let(:subject) { described_class.new(template, var_hash) }

  describe "#set_vars" do
    context "when hash is one level" do
      let(:var_hash) { {name: "Mike", age: 27} }
      before { subject.send(:set_vars) }
      it "should build vars from top level" do
        expect(subject.instance_variable_get(:@name)).to eq "Mike"
        expect(subject.instance_variable_get(:@age)).to eq 27
      end
      it "should define methods for variables" do
        expect(subject.name).to eq "Mike"
        expect(subject.age).to eq 27
      end
    end
    context "when hash is multiple levels" do
      let(:var_hash) { {
        people: [
          {
            name: 'Bob',
            age: 20,
            parents: ['Mary', 'Tom']
          }
        ],
        pet: { type: 'dog', name: 'Dany'}
      } }
      before { subject.send(:set_vars) }
      it "should build vars from top level" do
        expect(subject.instance_variable_get(:@people)).to be_a Array
        expect(subject.instance_variable_get(:@people)[0][:parents].first).to eq 'Mary'
        expect(subject.instance_variable_get(:@pet)[:name]).to eq 'Dany'
      end
      it "should define methods for variables" do
        expect(subject.people).to be_a Array
        expect(subject.people[0][:parents].first).to eq 'Mary'
        expect(subject.pet[:name]).to eq 'Dany'
      end
    end
    context "when hash key ends in a question mark" do
      let(:var_hash) { {
        name?: true
      } }
      it "should have a predicate method" do
        expect(subject.name?).to be true
      end
      it "should not have a plain reader method" do
        expect{subject.name}.to raise_error(NoMethodError)
      end
    end
  end

  describe "#render" do
    before do
      allow(subject).to receive(:name) { "Mike" }
      allow(subject).to receive(:age) { "27" }
    end
    let(:template) { "Hello <%= name %>. You are <%= age %> years old." }
    it "should render ERB successfully" do
      expect(subject.render).to eq "Hello Mike. You are 27 years old."
    end
  end

end
