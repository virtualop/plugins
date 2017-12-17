description "converts a pre-installed spare machine into a usable installation"

param! :machine, "the spare to convert"
param! "new_name", "name for the new machine"

run do |machine, new_name|
  # TODO sanity check that this is called on a spare vm, not a host?
  # TODO sanity check that the spare is in a usable state?

  installation = Installation.find_or_create_by(host_name: machine.parent.name, vm_name: machine.name.split(".").first)
  installation.status = :converting
  installation.save!

  vm_name = machine.name.split(".").first
  $logger.info "converting #{vm_name} into #{new_name} ..."

  # rename and shutdown
  machine.set_hostname("new_name" => new_name)
  begin
    machine.sudo "shutdown -h now"
  rescue
    $logger.info "caught exception during VM shutdown, probably normal"
  end

  host = machine.parent
  @op.wait("timeout" => 120, "block" => lambda do
    vm = host.list_vms!.select { |x| x["name"] == vm_name }.first
    raise "vm #{vm_name} not found on #{host.name}" if vm.nil?

    vm["state"] == "shut off"
  end)

  # libvirt rename
  host.rename_vm("vm_name" => vm_name, "new_name" => new_name)

  # scan again so that we have SSH connect metadata
  scanned = host.list_vms_for_scan
  @op.machines_found(scanned)

  # TODO adjust memory, CPU and disk (see 0.2.x)

  # start converted VM
  host.start_vm("name" => new_name)

  @op.wait("timeout" => 120, "block" => lambda do
    new_vm_list = @op.list_vms!("machine" => host.name)
    vm = new_vm_list.select { |x| x["name"] == new_name }.first
    raise "vm #{new_name} not found on #{host.name}" if vm.nil?

    vm["state"] == "running"
  end)

  full_name = "#{new_name}.#{host.name}"

  # wait until vm_addresses returns a meaningful result
  @op.wait(
    "timeout" => 30,
    "block" => lambda do
      addresses = host.vm_addresses!("name" => new_name)
      $logger.debug "addresses : #{addresses.pretty_inspect}"
      ! addresses.nil? && ! addresses.empty?
    end
  )

  @op.ssh_options!("machine" => full_name)

  installation.status = :converted
  installation.save!

  full_name
end
