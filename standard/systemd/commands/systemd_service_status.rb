param! :machine
param! "service", default_param: true

run do |machine, service|
  machine.ssh("systemctl status #{service}")
end
