description "sets the maximally available amount of memory for this VM"

param! :machine
param! "name"
param! "value", "the new amount of memory (in MB)"

run do |machine, params|
  value_in_megabyte = params["value"]
  machine.ssh "virsh setmaxmem #{params["name"]} #{value_in_megabyte}M --config"
end
