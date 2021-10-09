param! "name"

param :machine, description: "a virtualization host on which the VM should be created"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25

run do |params, name, machine|
  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "preparing"
  )

  params.delete("machine")
  machine.new_vm_from_spare(params)

  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "prepared"
  )
end
