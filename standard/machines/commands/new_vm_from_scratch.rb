param! "name"

param! :machine, description: "a virtualization host on which the VM should be created"

run do |machine, name, params|
  @op.new_vm_from_latest_ubuntu(params)

  "#{name}.#{machine.name}"
end
