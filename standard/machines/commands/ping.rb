description "call ping to check if a machine is reachable on the network"

param! :machine, :default_param => true

param "count", :default => 1
param "verbose", :default => false

run do |params, machine|
  params["address"] = machine.name
  @op.ping_address(params)
end
