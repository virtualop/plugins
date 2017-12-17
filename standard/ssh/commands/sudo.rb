param! :machine
param! "command", default_param: true

run do |machine, params|
  machine.ssh("command" => "sudo #{params["command"]}", "request_pty" => true)
end
