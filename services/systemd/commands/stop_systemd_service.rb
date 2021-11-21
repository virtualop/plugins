param! :machine
param_service

run do |machine, service|
  machine.sudo("systemctl stop #{service}")
  machine.list_systemd_services!
end
