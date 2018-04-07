param! :machine

run do |machine|
  found = machine.list_vms!.map do |vm|
    vm["type"] = "vm"
    vm["name"] = "#{vm["name"]}.#{machine.name}"
    vm["source"] = "libvirt"
    vm
  end
  @op.machines_found(found)

  found.each do |vm|
    @op.inspect_async vm["name"]
  end
end
