param! "name"

param! :machine, description: "a virtualization host on which the VM should be created"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25

run do |machine, name, params|
  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "installing"
  )

  @op.new_vm_from_latest_ubuntu(params)

  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "installed"
  )

  "#{name}.#{machine.name}"
end
