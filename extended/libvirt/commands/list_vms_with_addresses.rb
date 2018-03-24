param! :machine

run do |machine|
  machine.list_vms.map do |vm|
    $logger.debug "vm : #{vm.pretty_inspect}"

    metadata = @op.metadata("#{vm["name"]}.#{machine.name}")
    # workaround for old vop 0.2.x-style VMs that do not have domifaddr:
    if metadata.has_key?("source") && metadata["source"] == "list_old_v2_vms"
      if metadata.has_key?("ip")
        vm["address"] = metadata["ip"]
      end
    else
      if vm["state"] == "running"
        vm["address"] = machine.vm_address("name" => vm["name"])
      end
    end
    vm
  end
end
