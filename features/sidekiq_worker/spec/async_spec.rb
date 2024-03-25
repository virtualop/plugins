require_relative "../../../spec/spec_helper"

RSpec.describe Vop do
  before(:example) do    
    @vop = test_vop
    @vop.plugin("async_test").init

    tmp_file = "/tmp/async_test.log"
    File.delete(tmp_file) if File.exists?(tmp_file)
  end

  it "executes commands asynchronously", :sidekiq_inline do
    current_time = Time.now.to_i
    request = Vop::Request.new(@vop, "write_tmp_file", { "machine" => "localhost", "content" => current_time.to_s })
    @vop.execute_async(the_request: request, vop_config: { optional_plugins: ["async_test"] })
    expect(IO.read("/tmp/async_test.log").to_i).to eql(current_time)
  end
end
