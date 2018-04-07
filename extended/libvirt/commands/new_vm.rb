param! :machine

param! "name"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25
param "iso_path", description: "path to the ISO image of an installation CD",
  default: "/data/libvirt/isos/ubuntu-16.04.3-server-amd64.rebuilt17.iso"
param "vnc_listen_address", description: "address on which the VM should be accessible through VNC", default: "127.0.0.1"

param "no_os_variant", default: true # On Ubuntu 17.10, there's no OS variant for ubuntu 17.10...

run do |machine, name, memory, cpu_count, disk_size, iso_path, vnc_listen_address, no_os_variant|
  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "provisioning"
  )

  $logger.info "starting to install VM '#{name}' on '#{machine.name}'"

  begin
    image_dir = "/var/lib/libvirt/images"
    image_path = "#{image_dir}/#{name}.img"

    os_type = "linux"
    os_variant = nil
    file_name = File.basename(iso_path)
    # TODO would be nice if this would support more distros
    if file_name =~ /ubuntu-([\d\.]+)-/
      numbers = $1
      version = numbers.split(".")[0..1].join(".")
      os_variant = "ubuntu#{version}"
    end

    command = "virt-install" \
              " --name #{name}" \
              " --ram #{memory}" \
              " --vcpus #{cpu_count}" \
              " --os-type=#{os_type}"

    if os_variant && ! no_os_variant
      command += " --os-variant=#{os_variant}"
    end

    command += " --accelerate" \
              " --network network=default,model=virtio" \
              " --disk path=#{image_path},size=#{disk_size},sparse=false,cache=none,bus=virtio" \
              " --cdrom #{iso_path}" \
              " --graphics vnc,listen=#{vnc_listen_address}" \
              " -v"
    machine.sudo(command)

    # TODO extract everything below into its own command (e.g. in :machines?)
    scanned = machine.list_vms_for_scan
    @op.machines_found(scanned)

    host_name = machine.name
    full_name = "#{name}.#{host_name}"
    vm = @op.machines[full_name]
    $logger.info "vm setup complete, testing SSH connect to #{vm.name}..."
    $logger.debug "ssh options : #{vm.ssh_options}"

    # remove old host key
    machine.vm_addresses!(name: name)
    vm_address = machine.vm_address(name: name)
    @op.clean_known_host(ip: vm_address)

    $logger.info "waiting 5"
    sleep 5

    success = 0
    max_tries = 25
    max_tries.downto(0) do |idx|
      break if success >= 3
      $logger.info "waiting 2 [##{idx}]"
      sleep 2
      begin
        machine.vm_addresses!("name" => name)
        vm.ssh_options!
        if vm.test_ssh!
          success += 1
          $logger.info "ssh connects successful : #{success}"
        end
      rescue => e
        $logger.error "ssh connect failed : #{e.message}"
      end
    end

    @op.track_installation_status(
      host_name: machine.name,
      vm_name: name,
      status: "provisioned"
    )
  rescue => e
    @op.track_installation_status(
      host_name: machine.name,
      vm_name: name,
      status: "provisioning_failed"
    )
    $logger.error("provisiong of vm #{name} on host #{machine.name} failed: #{e.message}\n#{e.backtrace.join("\n")}")
  end

  $logger.info "new machine #{name} provisioned on host #{machine.name}"

  machine.list_vms!
  machine.processes!

  vm
end
