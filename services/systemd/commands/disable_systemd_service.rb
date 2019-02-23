param! :machine
param_service

run do |machine, service|
  machine.sudo("systemctl disable #{service}")

  machine.list_systemd_services!
end
