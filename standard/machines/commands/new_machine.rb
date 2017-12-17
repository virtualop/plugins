param! "name"

param :machine, description: "a virtualization host on which the VM should be created"

run do |params, name, machine|
  unless params.has_key?("machine")
    params["machine"] = "cabildo.traederphi"
  end

  new_vm_command = "new_vm_from_spare"
  @op.execute(new_vm_command, params)

  installation = Installation.find_or_create_by(host_name: machine.name, vm_name: name)
  installation.status = :finished
  installation.save!
end
