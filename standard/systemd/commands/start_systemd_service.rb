param! :machine
param_service

run do |machine, service|
  machine.sudo("systemctl start #{service}")
end
