require "bundler/setup"
require "vop"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def test_spec_path(sub_tree)
  Pathname.new(File.join(File.dirname(__FILE__), "lib", "vop", sub_tree)).realpath
end

def test_vop(sub_tree = nil, options = {})
  # set all possible env variables to satisfy coverage
  ENV["VOP_DEV_MODE"] = "yup"
  ENV["VOP_ORIGIN"] = "rspec"

  unless sub_tree.nil?
    options[:plugin_path] = test_spec_path(sub_tree)
  end

  Vop.setup(options)
end
