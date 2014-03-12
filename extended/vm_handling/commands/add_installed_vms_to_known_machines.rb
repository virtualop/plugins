description 'adds all VMs that have been installed on a libvirt host and adds entries for them to the list of known machines'

param :machine

on_machine do |machine, params|
  machine.list_installed_vms.each do |vm|
    
    full_name = vm["vm_name"] + "." + machine.name

    options = {
      'type' => 'vm',
      'host_name' => machine.name,
      'name' => full_name      
    }

    ip_address = nil    
    if vm['ipaddress'] && vm['ssh_port']
      options['ssh_port'] = vm['ssh_port']
      options['ssh_host'] = machine.ipaddress      
    else
      # no IP specified, check if there's a DHCP lease from libvirt
      @op.without_cache do
        dhcp_address = machine.libvirt_dhcp.select { |x| x['hostname'] == vm['vm_name'] }.first
        if dhcp_address
          # TODO this assumes that the host is configured to forward .foo DNS requests to libvirt's dnsmasq
          options['ssh_host'] = vm['vm_name'] + '.foo'
        end
      end
    end
    
    if options['ssh_host']
      @op.add_known_machine(options)
    end
  end
end
