contribute to: "scan_machines" do
  result = []

  @op.machines.each do |machine|
    # we're interested in VMs installed on physical hosts
    if machine.metadata.has_key?("server_ip") && machine.distro =~ /^centos/
      result += machine.list_old_v2_vms
    end
  end

  result
end
