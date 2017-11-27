RSpec.describe Playwright::Play::Service do
  let(:subject) { described_class.new(base_url)}

  describe "#get" do
    context "when base_url is 'https://jsonplaceholder.typicode.com/posts'" do
      let(:base_url) { 'https://jsonplaceholder.typicode.com/posts' }
      it "should return 100 posts" do
        expect(subject.get.size).to eq 100
      end
    end
  end

end