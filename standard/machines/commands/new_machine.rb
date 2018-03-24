param! "name"

param :machine, description: "a virtualization host on which the VM should be created"

run do |params, name, machine|
  unless machine
    machine = @op.machines["cabildo.traederphi"]
  end

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
