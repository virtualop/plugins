param! 'machine'
param! 'command_string'

run do |params, machine|
  if machine.name == 'localhost'
    @op.system_call(params["command_string"])
  else
    machine.ssh(params)
  end
end
