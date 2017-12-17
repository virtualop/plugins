contribute to: "scan_machines" do
  result = []

  @op.machines.each do |machine|
    # we're interested in VMs installed on physical hosts
    if machine.metadata.has_key?("server_ip") && machine.distro =~ /^ubuntu/
      result += machine.list_vms_for_scan
    end
  end

  result
end
