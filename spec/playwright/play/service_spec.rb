RSpec.describe Playwright::Play::Service do
  let(:subject) { described_class.new(base_url: base_url, resource: resource)}

  describe "#get" do
    context "when base_url is 'https://jsonplaceholder.typicode.com/' and resource is 'posts'" do
      let(:base_url) { 'https://jsonplaceholder.typicode.com' }
      let(:resource) { 'posts' }

      it "should have #success? be true" do
        expect(subject.get.success?).to be true
      end
      it "should return 100 posts" do
        expect(subject.get.response.size).to eq 100
      end
    end
    context "when base_url is invalid and resource is 'posts'" do
      let(:base_url) { 'https://asdfasbjahlk34.aldskfasasagah.aliksjlksj.com' }
      let(:resource) { 'posts' }

      it "should return a failure status" do
        expect(subject.get.failure?).to be true
      end
    end
  end

  describe "#post" do
    context "when base_url is 'https://jsonplaceholder.typicode.com' and resource is 'posts'" do
      let(:base_url) { 'https://jsonplaceholder.typicode.com' }
      let(:resource) { 'posts' }
      let(:data) { {title: "This is a title", body: "Lots of text here"} }

      it "should return a success status" do
        expect(subject.post(data).success?).to be true
      end
    end
    context "when base_url is invalid and resource is 'posts'" do
      let(:base_url) { 'https://asdfasbjahlk34.aldskfasasagah.aliksjlksj.com' }
      let(:resource) { 'posts' }
      let(:data) { {title: "This is a title", body: "Lots of text here"} }

      it "should return a failure status" do
        expect(subject.post(data).failure?).to be true
      end
    end
  end

  describe "#full_url" do
    context "when there is no slash on base_url" do
      context "when there is a resource" do
        let(:base_url) { 'https://hello.com'}
        let(:resource) { 'posts' }

        it "should return the {url/post}" do
          result = "https://hello.com/posts"
          expect(subject.send(:full_url)).to eq result
        end
      end
      context "when there is no resource" do
        let(:base_url) { 'https://hello.com'}
        let(:resource) { nil }

        it "should return the {url/post}" do
          result = "https://hello.com/"
          expect(subject.send(:full_url)).to eq result
        end
      end
    end
    context "when there is a slash on base_url" do
      context "when there is a resource" do
        let(:base_url) { 'https://hello.com/'}
        let(:resource) { 'posts' }

        it "should return the {url/post}" do
          result = "https://hello.com/posts"
          expect(subject.send(:full_url)).to eq result
        end
      end
      context "when there is no resource" do
        let(:base_url) { 'https://hello.com/'}
        let(:resource) { nil }

        it "should return the {url/post}" do
          result = "https://hello.com/"
          expect(subject.send(:full_url)).to eq result
        end
      end
    end
  end

end