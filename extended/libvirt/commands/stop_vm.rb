param! :machine
param! "name"

run do |machine, name|
  # in libvirt-speak, "stop" is called "destroy" (and "undefine" is what kills a VM)
  machine.sudo "virsh destroy #{name}"
  machine.list_vms!
end
