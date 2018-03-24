param! :machine
param! "service", default_param: true

run do |machine, service|
  machine.sudo("systemctl start #{service}")
end
