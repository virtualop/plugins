contribute to: "scan_machines" do
  result = []

  @op.machines.each do |machine|
    # we're interested in VMs installed on physical hosts
    # TODO the server_ip is hetzner-specific => extract into xop-libvirt ?
    if machine.metadata.has_key?("server_ip") # TODO && machine.distro =~ /^ubuntu/
      begin
        result += machine.list_vms_for_scan
      rescue => e
        $logger.error("could not list VMs on #{machine.name} : #{e.message}")
      end
    end
  end

  result
end
