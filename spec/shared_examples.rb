# Requires method variable to be set to method being tested
RSpec.shared_examples "should not exit" do
  around(:each) do |example|
    begin
      example.run
    rescue Playwright::PlaywrightExit
      fail("Playwright exited!")
    end
  end
  it "should not exit" do
    raise NoMethodError if !defined?(method) || !method
    expect{subject.send(method)}.not_to raise_error(Playwright::PlaywrightExit)
    expect{subject.send(method)}.not_to raise_error
  end
end

# Requires method variable to be set to method being tested
RSpec.shared_examples "should exit" do
  around(:each) do |example|
    begin
      example.run
    rescue Playwright::PlaywrightExit
    end
  end
  it "should exit" do
    raise NoMethodError if !defined?(method)
    expect{subject.send(method)}.to raise_error(Playwright::PlaywrightExit)
  end
end