description "changes the amount of memory available for this VM (see also set_maxmem)"

param! :machine
param! "name"
param! "value", "the new amount of memory (in MB)"

run do |machine, params|
  value_in_megabyte = params["value"]
  machine.ssh "virsh setmem #{params["name"]} #{value_in_megabyte}M"
end
