param! :machine

run do |machine|
  machine.list_vms!.map do |vm|
    #machine.vm_addresses!("name" => vm["name"])

    vm["type"] = "vm"
    vm["name"] = "#{vm["name"]}.#{machine.name}"
    vm["source"] = "libvirt"
    vm
  end
end
