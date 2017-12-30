param! :machine

run do |machine|
  machine.list_vms.map do |vm|
    $logger.debug "vm : #{vm.pretty_inspect}"
    if vm["state"] == "running"
      vm["address"] = machine.vm_address("name" => vm["name"])
    end
    vm
  end
end
