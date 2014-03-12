description 'setup a new vm'

param :machine, 'a host to install the new VM on'

param! "vm_name", "the name for the VM to be created"

param "memory_size", "the amount of memory (in MB) that should be allocated for the new VM", :default_value => 512
param "disk_size", "disk size in GB for the new VM", :default_value => 25
param "vcpu_count", "the number of virtual CPUs to allocate", :default_value => 1

param "ip", "the static IP address for the new machine"

param "template", "name of a predefined set of location and kickstart URLs. see list_vm_templates", 
  :lookup_method => lambda { @op.list_vm_templates.pick(:name) }
  
param "os_variant", "...", :default_value => 'virtio26'
param "os_type", "...", :default_value => 'linux'

param "environment", "if specified, the environment is written into a config file so that it's available through $VOP_ENV", :lookup_method => lambda {
  @op.list_environments
}

param "canned_service", "name of a canned service to install on the machine", :allows_multiple_values => true
param :github_project
param :git_branch
param :git_tag

param "script_url", "http URL to a script that should be executed at the end of the installation"

accept_extra_params  

as_root do |machine, params|  
  
  machine_name = params['machine']
  full_name = params["vm_name"] + "." + machine_name
  
  # TODO lock
  #@op.with_lock("name" => "setup_vm_new", "extra_params" => { "machine" => params["machine"] }) do
    p = params.clone
    p.merge!(
      "nameserver" => machine.first_configured_nameserver,      
    )
    # if params['ip']
      # parts = params["ip"].split("\.")[0..2]
      # parts << '1'
      # gateway = parts.join(".")
      # p.merge!(
        # "gateway" => gateway
      # )
    # end
    
    if params['template']
      template = @op.list_vm_templates.select { |x| x['name'] == params['template'] }.first
      if template
        p['location'] = template['location']
        p['kickstart_url'] = config_string('kickstart_url') + '/' + template['kickstart']
      end
    else
      p.merge!(
        'location' => config_string('install_kernel_location'),
        'kickstart_url' => config_string('kickstart_url_vm'),
      )
    end
    
    #machine.new_vm_from_kickstart(p)
    machine.new_vm(p)
    
    @op.flush_cache
    
    @op.without_cache do
      puts "before : "
      puts machine.libvirt_dhcp
    end
    
    @op.without_cache do
      machine.add_installed_vms_to_known_machines
      @op.list_known_machines
      @op.list_machines
    end
  #end
  
  # wait until shutdown after installation
  @op.wait("timeout" => config_string('installation_timeout_secs').to_i, 
    "error_text" => "could not find a machine with name '#{params["vm_name"]}' that is shut off") do
    @op.cache_bomb
    candidates = machine.list_vms.select do |row|
      row["name"] == params["vm_name"] and
      row["state"] == "shut off"
    end
    candidates.size > 0
  end
  
  machine.fix_libvirt_timezone_config("name" => params["vm_name"])
  
  machine.start_vm("name" => params["vm_name"])
  
  sleep 5
  
  @op.wait("timeout" => config_string('vm_start_timeout_secs'), 
    "error_text" => "could not find a running machine with name '#{params["vm_name"]}'") do
    @op.without_cache do
      @op.comment "second round : add_installed_vms_to_known_machines:"
      puts machine.libvirt_dhcp
      puts machine.add_installed_vms_to_known_machines
      @op.list_known_machines
      @op.list_machines
    end
      
    @op.cache_bomb
    @op.reachable_through_ssh("machine" => full_name)
  end
  
  @op.with_machine(full_name) do |vm|
    vm.base_install(params)
    
    vm.os_update   
    
    if params.has_key?('canned_service')
      params['canned_service'].each do |canned_service|
        p = {
          "service" => canned_service
        }
        if params.has_key?("extra_params")
          p["extra_params"] = params["extra_params"]
        end
        vm.install_canned_service(p)
      end
    end
    
    if params.has_key?('github_project')
      vm.install_service_from_github(params) 
    end  
    
    if params.has_key?('script_url')
      vm.execute_remote_command("url" => params['script_url'])
    end
    
    # kind of sad, but seems to make more sense for now to use the proxy for the installation only
    if vm.file_exists("file_name" => "/etc/profile.d/http_proxy.sh") && ! params["keep_proxy"] 
      vm.rm("file_name" => "/etc/profile.d/http_proxy.sh")
    end
    
    vm.change_runlevel("runlevel" => "running")
    
    vm.hash_to_file("file_name" => "/var/lib/virtualop/setup_params", "content" => params)
  end
  
  group_for_host = @op.list_machine_groups.select { |x| x["name"] == machine_name }.first
  if group_for_host
    @op.without_cache do
      @op.list_machine_group_children("machine_group" => machine_name)
    end
  end 
  
  full_name
end