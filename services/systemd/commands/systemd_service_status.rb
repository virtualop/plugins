param! :machine
param_service

run do |machine, service|
  machine.ssh("systemctl status #{service}")
end
