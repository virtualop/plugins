# TODO params_as ssh_call ?

param! "machine"
param! "command", :default_param => true

param "request_pty", :default => false
param "show_output", default: false

run do |params|
  result = @op.ssh_call(params)

  unless result["result_code"].to_i == 0
    exception_with_backtrace = StandardError.new("SSH result code not zero")
    exception_with_backtrace.set_backtrace(result["combined"])
    raise exception_with_backtrace
  end

  result["combined"]
end
