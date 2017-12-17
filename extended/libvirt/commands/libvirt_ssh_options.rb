param! :machine

contribute to: "ssh_options" do |machine, params|
  result = {}

  # connect to new-style libvirt VMs through the parent host as ProxyJump host
  if machine.metadata.has_key?("source") &&
     machine.metadata["source"] == "libvirt"

     # extract the parent host from the VM name
     parent_name = machine.name.split(".")[1..-1].join(".")
     result["jump_host"] = parent_name

     # from the jump host, we connect to the VM's internal IP
     vm_short_name = machine.name.split(".").first
     vm_ip = @op.vm_address("machine" => parent_name, "name" => vm_short_name)
     result["host_or_ip"] = vm_ip

     result["user"] = "marvin"
     result["password"] = "foobar123"
  end

  result
end
