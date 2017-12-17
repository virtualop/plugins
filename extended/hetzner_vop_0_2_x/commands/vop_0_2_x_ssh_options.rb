param! :machine

contribute to: "ssh_options" do |machine, params|
  result = {}

  # connect as root to the physical hosts
  if machine.metadata.has_key? "server_ip"
    result["host_or_ip"] = machine.metadata["server_ip"]
    result["user"] = "root"
  elsif machine.metadata.has_key?("vcpu_count") && machine.metadata.has_key?("ip")
    host_name = machine.id.split(".")[1..-1].join(".")
    # connect to the VM through the host's IP
    result["host_or_ip"] = @op.ssh_options(machine: host_name)["host_or_ip"]
    result["user"] = "root"
    result["password"] = "the_password"
    result["port"] = machine.metadata["ip"].split(".").last.to_i + 2200
  end

  result
end
