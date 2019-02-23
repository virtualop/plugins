param! :machine
param! "name"

run do |machine, name|
  machine.sudo "virsh start #{name}"
  machine.list_vms!
end
