description "returns the host's ip addresses (currently this means eth0)"

param! :machine
param "interface", description: "name of the interface", default_value: "eth0"

read_only

run do |machine, params|
  machine.list_ip_addresses('device' => params['interface']).first["address"]
end
