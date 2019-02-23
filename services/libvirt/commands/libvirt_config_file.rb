param! "vm_name", "name of the vm"

run do |vm_name|
  "/etc/libvirt/qemu/#{vm_name}.xml"
end
