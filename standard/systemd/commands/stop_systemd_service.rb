param! :machine
param_service

run do |machine, service|
  machine.sudo("systemctl stop #{service}")
end
