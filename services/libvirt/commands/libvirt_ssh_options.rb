# TODO extract into xop-libvirt

param! :machine

contribute to: "ssh_options" do |machine, params, plugin|
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

     if plugin.config["ssh_user"].nil? || plugin.config["ssh_password"].nil?
       raise "missing configuration - expected 'ssh_user' and 'ssh_password' in config for #{plugin.name}"
     end
     result["user"] = plugin.config["ssh_user"]
     result["password"] = plugin.config["ssh_password"]
  end

  result
end
