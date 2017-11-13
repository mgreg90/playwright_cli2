require 'bundler/setup'
require 'playwright'
require 'memfs'

def suppress_print(config)
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end


require File.join(File.dirname(__FILE__), "shared_examples.rb")
require 'spec_config.rb'
