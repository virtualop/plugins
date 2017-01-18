param! "address", :default_param => true

param "count", :default => 1
param "verbose", :default => false

run do |address, count, verbose|
  output = `ping -c #{count} #{address}`
  ping_ok = $?.exitstatus == 0
  puts output if verbose
  ping_ok
end
