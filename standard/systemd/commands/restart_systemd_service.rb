param! :machine
param_service

run do |machine, service|
  machine.sudo("systemctl restart #{service}")

  machine.list_systemd_services!
end
