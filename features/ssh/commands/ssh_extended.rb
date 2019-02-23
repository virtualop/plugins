param :machine
param! "command", default_param: true

run do |params|
  @op.ssh_call(params)
end
