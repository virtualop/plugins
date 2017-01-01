description "call ping to check if a machine is reachable on the network"

param! :machine, :default_param => true

param "count", :default => 1
param "verbose", :default => false

run do |machine, count, verbose|
  output = `ping -c #{count} #{machine.name}`
  ping_ok = $?.exitstatus == 0
  puts output if verbose
  ping_ok
end
