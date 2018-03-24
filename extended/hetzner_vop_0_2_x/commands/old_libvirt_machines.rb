contribute to: "scan_machines" do
  result = []

  @op.machines.each do |machine|
    # we're interested in VMs installed on physical hosts (that have an IP)
    begin
      if machine.metadata.has_key?("server_ip") && machine.distro =~ /^centos/
        result += machine.list_old_v2_vms
      end
    rescue => e
      $logger.error("could not list old 0.2.x-style VMs on #{machine.name} : #{e.message}")
    end
  end

  result
end
