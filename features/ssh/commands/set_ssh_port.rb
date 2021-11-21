param! :machine
param! "port"

run do |machine, port|
  machine.update_metadata new_data: { ssh_port: port }
end
