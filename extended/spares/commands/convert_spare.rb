description "converts a pre-installed spare machine into a usable installation"

param! :machine, "the spare to convert"
param! "new_name", "name for the new machine"

param "memory", description: "in MB", default: 512
# param "cpu_count", default: 1
# param "disk_size", description: "in GB", default: 25

run do |machine, new_name, memory|
  host = machine.parent
  host_name = machine.name

  # TODO check that this is called on a spare vm, not a host?
  # TODO check that the spare is in a usable state?

  @op.track_installation_status(
    host_name: host_name,
    vm_name: new_name,
    status: "converting"
  )

  vm_name = machine.name.split(".").first
  $logger.info "converting #{vm_name} into #{new_name} ..."

  begin
    # rename and shutdown
    machine.set_hostname("new_name" => new_name)
    begin
      machine.sudo "shutdown -h now"
    rescue
      $logger.info "caught exception during VM shutdown, probably normal"
    end

    @op.wait(timeout: 120) do
      vm = host.list_vms!.select { |x| x["name"] == vm_name }.first
      raise "vm #{vm_name} not found on #{host.name}" if vm.nil?

      vm["state"] == "shut off"
    end

    # libvirt rename
    host.rename_vm("vm_name" => vm_name, "new_name" => new_name)

    # scan again so that we have SSH connect metadata
    scanned = host.list_vms_for_scan
    @op.machines_found(scanned)

    # TODO adjust CPU and disk (see 0.2.x)
    host.set_maxmem("name" => new_name, "value" => memory) unless memory.nil?

    # start converted VM
    host.start_vm("name" => new_name)

    @op.wait(timeout: 120) do
      new_vm_list = @op.list_vms!("machine" => host.name)
      vm = new_vm_list.select { |x| x["name"] == new_name }.first
      raise "vm #{new_name} not found on #{host.name}" if vm.nil?

      vm["state"] == "running"
    end

    host.set_mem("name" => new_name, "value" => memory) unless memory.nil?

    full_name = "#{new_name}.#{host.name}"

    # wait until vm_addresses returns a meaningful result
    @op.wait(timeout: 30) do
      addresses = host.vm_addresses!("name" => new_name)
      $logger.debug "addresses : #{addresses.pretty_inspect}"

      ! addresses.nil? && ! addresses.empty?
    end

    @op.ssh_options!("machine" => full_name)

    # clean previous SSH keys for VMs with the same name/IP
    vm_address = host.vm_address(name: new_name)
    @op.clean_known_host(ip: vm_address)

    @op.track_installation_status(
      host_name: host_name,
      vm_name: new_name,
      status: "converted"
    )
  rescue => detail
    $logger.error "problem converting spare #{vm_name} into #{new_name} : #{detail.message}"
    @op.track_installation_status(
      host_name: host_name,
      vm_name: new_name,
      status: "converting_failed"
    )
  ensure
    host.post_convert_spare("converted" => vm_name)
  end

  full_name
end
