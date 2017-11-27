RSpec.describe Playwright::Params do
  let(:subject) { described_class.new(raw_args, arg_map, opts_map)}
  let(:raw_args) { [] }
  let(:arg_map) { [] }
  let(:opts_map) { [] }
  describe "self" do

    context "when arg_map is []" do
      let (:arg_map) { [] }
      context "when raw_args are ['hello']" do
        let(:raw_args) { ['hello'] }
        it "should respond to [0] with 'hello'" do
          expect(subject[0]).to eq 'hello'
        end
      end
      context "when raw_args are ['hello', 'mike']" do
        let(:raw_args) { ['hello', 'mike'] }
        it "should respond to [0] with 'hello'" do
          expect(subject[0]).to eq 'hello'
        end
        it "should respond to :first with 'hello'" do
          expect(subject.first).to eq 'hello'
        end
        it "should respond to [1] with 'mike'" do
          expect(subject[1]).to eq 'mike'
        end
        it "should respond to :second with 'mike'" do
          expect(subject.second).to eq 'mike'
        end
        it "should respond to :third with nil" do
          expect(subject.third).to be nil
        end
      end
    end

    context "when arg_map is ['greeting']" do
      let(:arg_map) { ['greeting'] }
      context "when raw_args are []" do
        let(:raw_args) { [] }
        it "should have a defined greeting method" do
          expect(subject).to respond_to(:greeting)
        end
        it "should respond to #greeting with nil" do
          expect(subject.greeting).to be nil
        end
      end
      context "when raw_args are ['hello']" do
        let(:raw_args) { ['hello'] }
        it "should have a defined greeting method" do
          expect(subject).to respond_to(:greeting)
        end
        it "should respond to [0] with 'hello'" do
          expect(subject[0]).to eq 'hello'
        end
        it "should respond to [:greeting] with 'hello'" do
          expect(subject[:greeting]).to eq 'hello'
        end
        it "should respond to ['greeting'] with 'hello'" do
          expect(subject['greeting']).to eq 'hello'
        end
      end
    end

    context "when opts_map is []" do
      let(:opts_map) { [] }
      context "when raw_args are []" do
        let(:raw_args) { [] }
        it "should not error" do
          expect(subject[0]).to be nil
        end
      end
      context "when raw_args are ['hello']" do
        let(:raw_args) { ['hello'] }
        it "should not error" do
          expect(subject[0]).to eq 'hello'
        end
      end
    end

    context "when opts map has one simple 'force' option" do
      let(:opts_map) { [{ short: 'f', long: 'force'}] }
      context "when raw args are []" do
        let(:raw_args) { [] }
        it "should respond to #force? with false" do
          expect(subject).to respond_to(:force?)
          expect(subject.force?).to be false
        end
        it "should respond to #force with false" do
          expect(subject).to respond_to(:force)
          expect(subject.force).to be false
        end
        it "should respond to [:force] with false" do
          expect(subject[:force]).to be false
        end
        it "should respond to ['force'] with false" do
          expect(subject['force']).to be false
        end
      end
      context "when raw args are ['-f']" do
        let(:raw_args) { ['-f'] }
        it "should respond to #force? with true" do
          expect(subject).to respond_to(:force?)
          expect(subject.force?).to be true
        end
        it "should respond to #force with true" do
          expect(subject).to respond_to(:force)
          expect(subject.force).to be true
        end
        it "should respond to [:force] with true" do
          expect(subject[:force]).to be true
        end
        it "should respond to ['force'] with true" do
          expect(subject['force']).to be true
        end
      end
      context "when raw args are ['--force']" do
        let(:raw_args) { ['--force'] }
        it "should respond to #force? with true" do
          expect(subject).to respond_to(:force?)
          expect(subject.force?).to be true
        end
        it "should respond to #force with true" do
          expect(subject).to respond_to(:force)
          expect(subject.force).to be true
        end
        it "should respond to [:force] with true" do
          expect(subject[:force]).to be true
        end
        it "should respond to ['force'] with true" do
          expect(subject['force']).to be true
        end
      end
    end

    context "when opts map has a 'database' option that requires a value" do
      let(:opts_map) { [{ short: 'd', long: 'database', require_value: true}] }
      context "when raw args are []" do
        let(:raw_args) { [] }
        it "should not have a #database? method" do
          expect(subject).not_to respond_to(:database?)
        end
        it "should respond to #database with nil" do
          expect(subject).to respond_to(:database)
          expect(subject.database).to be nil
        end
        it "should respond to [:database] with nil" do
          expect(subject[:database]).to be nil
        end
        it "should respond to ['database'] with nil" do
          expect(subject['database']).to be nil
        end
      end
      context "when raw args are ['-d', 'postgres']" do
        let(:raw_args) { ['-d', 'postgres'] }
        it "should not have a #database? method" do
          expect(subject).not_to respond_to(:database?)
        end
        it "should respond to #database with 'postgres'" do
          expect(subject).to respond_to(:database)
          expect(subject.database).to eq 'postgres'
        end
        it "should respond to [:database] with 'postgres'" do
          expect(subject[:database]).to eq 'postgres'
        end
        it "should respond to ['database'] with 'postgres'" do
          expect(subject['database']).to eq 'postgres'
        end
      end
      context "when raw args are ['--database=postgres']" do
        let(:raw_args) { ['--database=postgres'] }
        it "should not have a #database? method" do
          expect(subject).not_to respond_to(:database?)
        end
        it "should respond to #database with 'postgres'" do
          expect(subject).to respond_to(:database)
          expect(subject.database).to eq 'postgres'
        end
        it "should respond to [:database] with 'postgres'" do
          expect(subject[:database]).to eq 'postgres'
        end
        it "should respond to ['database'] with 'postgres'" do
          expect(subject['database']).to eq 'postgres'
        end
      end
      context "when raw args are ['--database']" do
        let(:raw_args) { ['--database'] }
        it "should not have a #database? method" do
          expect(subject).not_to respond_to(:database?)
        end
        it "should respond to #database with nil" do
          expect(subject).to respond_to(:database)
          expect(subject.database).to be nil
        end
        it "should respond to [:database] with nil" do
          expect(subject[:database]).to be nil
        end
        it "should respond to ['database'] with nil" do
          expect(subject['database']).to be nil
        end
      end
      context "when raw args are ['-d']" do
        let(:raw_args) { ['-d'] }
        it "should not have a #database? method" do
          expect(subject).not_to respond_to(:database?)
        end
        it "should respond to #database with nil" do
          expect(subject).to respond_to(:database)
          expect(subject.database).to be nil
        end
        it "should respond to [:database] with nil" do
          expect(subject[:database]).to be nil
        end
        it "should respond to ['database'] with nil" do
          expect(subject['database']).to be nil
        end
      end
    end
  end

  describe "#map_args" do
    let(:opts_map) { [{short: 'd', long: 'database', require_value: true}] }
    context "when map is shorter than args" do
      let(:arg_map) { ['name'] }
      let(:raw_args) { ['Mike', '27'] }
      it "should respond to #name with 'Mike'" do
        expect(subject.name).to eq 'Mike'
      end
    end
    context "when map is shorter than args" do
      let(:arg_map) { ['name', 'age'] }
      let(:raw_args) { ['Mike', '27'] }
      it "should respond to #name with 'Mike'" do
        expect(subject.name).to eq 'Mike'
      end
      it "should respond to #name with 'age'" do
        expect(subject.age).to eq '27'
      end
      context "when there is a short option in the middle" do
        let(:raw_args) { ['Mike', '-f', '27']}
        it "should respond to #name with 'Mike'" do
          expect(subject.name).to eq 'Mike'
        end
        it "should respond to #name with 'age'" do
          expect(subject.age).to eq '27'
        end
      end
      context "when there is a long option in the middle" do
        let(:raw_args) { ['Mike', '--database=postgres', '27']}
        it "should respond to #name with 'Mike'" do
          expect(subject.name).to eq 'Mike'
        end
        it "should respond to #name with 'age'" do
          expect(subject.age).to eq '27'
        end
      end
      context "when there is a short, value-taking option in the middle" do
        let(:raw_args) { ['Mike', '-d', 'postgres', '27']}
        it "should respond to #name with 'Mike'" do
          expect(subject.name).to eq 'Mike'
        end
        it "should respond to #name with 'age'" do
          expect(subject.age).to eq '27'
        end
      end
    end
  end

  describe "#opt_match?" do
    context "when short match" do
      it "should return true" do
        expect(subject.send(:opt_match?, "-f", {short: 'f'})).to be true
      end
    end
    context "when long match" do
      it "should return true" do
        expect(subject.send(:opt_match?, "--force", {long: 'force'})).to be true
      end
    end
    context "when no match" do
      it "should return false" do
        expect(subject.send(:opt_match?, "--force", {long: 'save'})).to be false
      end
    end
  end

  describe "#valid_opt_value?" do
    let(:require_value) { nil }
    let(:opt_map) { {long: 'database', short: 'd', require_value: require_value} }
    context "short format" do
      context "when required" do
        let(:require_value) { true }
        context "but not present" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "-d", opt_map)).to be false
          end
        end
        context "but is an option" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "-d", opt_map, '-f')).to be false
          end
        end
        context "and is not an option" do
          it "should return true" do
            expect(subject.send(:valid_opt_value?, "-d", opt_map, 'postgres')).to be true
          end
        end
      end
      context "when not required" do
        let(:require_value) { false }
        context "and is an option" do
          it "should return true" do
            expect(subject.send(:valid_opt_value?, "-d", opt_map, '-f')).to be true
          end
        end
        context "and is a value" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "-d", opt_map, 'postgres')).to be false
          end
        end
      end
    end

    context "long format" do
      context "when required" do
        let(:require_value) { true }
        context "but not present" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "--database", opt_map)).to be false
          end
        end
        context "but is an option" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "--database", opt_map, '-f')).to be false
          end
        end
        context "and present" do
          it "should return true" do
            expect(subject.send(:valid_opt_value?, "--database=postgres", opt_map)).to be true
          end
        end
        context "and present, with secong_term given" do
          it "should return true" do
            expect(subject.send(:valid_opt_value?, "--database=postgres", opt_map, '-f')).to be true
            expect(subject.send(:valid_opt_value?, "--database=postgres", opt_map, 'something')).to be true
          end
        end
      end
      context "when not required" do
        let(:require_value) { false }
        context "and present" do
          it "should return false" do
            expect(subject.send(:valid_opt_value?, "--database=postgres", opt_map)).to be false
          end
        end
        context "and not present" do
          it "should return true" do
            expect(subject.send(:valid_opt_value?, "--database", opt_map)).to be true
          end
        end
      end
    end
  end

end