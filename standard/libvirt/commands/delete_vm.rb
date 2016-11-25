param! "machine", :description => "the host machine on which the VM lives"
param! "name"

run do |machine, name|
  vm_row = machine.list_vms.select { |x| x[:name] == name }.first

  raise "VM not found in list_vms" unless vm_row

  if vm_row[:state] == 'running'
    machine.stop_vm(name: name)
  end

  machine.ssh("virsh undefine #{name}")

  # TODO cleanup volumes
end
