RSpec.describe String do

  describe "#to_camel_case" do
    context "when string is 'some_string'" do
      it "should return 'someString'" do
        expect("some_string".to_camel_case).to eq "someString"
      end
    end
    context "when string is '   some   string    '" do
      it "should return 'someString'" do
        expect("   some   string    ".to_camel_case).to eq "someString"
      end
    end
    context "when string is 'some/string- thi\'\"ng~+_)(*&^%$# {@! yo}'" do
      it "should return 'someStringThingYo'" do
        expect("some/string- thing~+_)(*&^%$# {@! yo}".to_camel_case)
          .to eq "someStringThingYo"
      end
    end
  end

  describe "#to_pascal_case" do
    context "when string is 'some_string'" do
      it "should return 'SomeString'" do
        expect("some_string".to_pascal_case).to eq "SomeString"
      end
    end
    context "when string is '   some   string    '" do
      it "should return 'SomeString'" do
        expect("   some   string    ".to_pascal_case).to eq "SomeString"
      end
    end
    context "when string is 'some/string- thi\'\"ng~+_)(*&^%$# {@! yo}'" do
      it "should return 'SomeStringThingYo'" do
        expect("some/string- thing~+_)(*&^%$# {@! yo}".to_pascal_case)
          .to eq "SomeStringThingYo"
      end
    end
  end

  describe "#to_snake_case" do
    context "when string is 'some_string'" do
      it "should return 'some_string'" do
        expect("some_string".to_snake_case).to eq "some_string"
      end
    end
    context "when string is 'PascalCase'" do
      it "should return 'pascal_case'" do
        expect("PascalCase".to_snake_case).to eq "pascal_case"
      end
    end
    context "when string is 'camelCase'" do
      it "should return 'camel_case'" do
        expect("camelCase".to_snake_case).to eq "camel_case"
      end
    end
    context "when string is 'some/string- thing\'\"~+_)(*&^%$# {@! yo}'" do
      it "should return 'some_string_thing_yo'" do
        expect('some/string- thing\'\"~+_)(*&^%$# {@! yo}'.to_snake_case)
          .to eq "some_string_thing_yo"
      end
    end
  end

  describe "#to_dash_case" do
    context "when string is 'some_string'" do
      it "should return 'some-string'" do
        expect("some_string".to_dash_case).to eq "some-string"
      end
    end
    context "when string is 'PascalCase'" do
      it "should return 'pascal-case'" do
        expect("PascalCase".to_dash_case).to eq "pascal-case"
      end
    end
    context "when string is 'camelCase'" do
      it "should return 'camel-case'" do
        expect("camelCase".to_dash_case).to eq "camel-case"
      end
    end
    context "when string is 'some/string- thing\'\"~+_)(*&^%$# {@! yo}'" do
      it "should return 'some-string-thing-yo'" do
        expect('some/string- thing\'\"~+_)(*&^%$# {@! yo}'.to_dash_case)
          .to eq "some-string-thing-yo"
      end
    end
  end

  describe "#to_const" do
    context "when string is 'Hash'" do
      it "should return Hash class" do
        expect("Hash".to_const).to eq Hash
      end
    end
    context "when string is 'ThisIsAbsoluteGarbageYo'" do
      it "should raise a NameError" do
        expect{"ThisIsAbsoluteGarbageYo".to_const}.to raise_error(NameError)
      end
    end
  end

end