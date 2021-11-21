param! "machine"
param! "command", :default_param => true

run do |params|
  result = @op.ssh_call(params)

  result["result_code"].to_i == 0
end
