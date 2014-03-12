description 'invokes virt-install to create a new virtual machine'

param :machine
param! "vm_name", "the name for the VM to be created"

param! "memory_size", "the amount of memory (in MB) that should be allocated for the new VM"
param! "vcpu_count", "the number of virtual CPUs to allocate"

param "bridge", "the network bridge that should be used"
param "ip", "the static IP address for the new machine"
param "netmask", "a netmask to use with +ip+ for the new machine"
param "gateway", "default gateway to use in the new VM"
param "nameserver", "DNS servers that should be used in the new VM"

param "location", "Installation source for guest virtual machine kernel+initrd pair."
param "extra_arg", "extra arguments to pass to the installer when performing an installation from 'location'", 
  :allows_multiple_values => true,
  :default_value => [ 'console=ttyS0,115200' ]
param "kickstart_url", "http url for fetching a kickstart script"  

param "cdrom", "path to an ISO image or a CDROM device"
param "livecd", "set to true for live cd images that should be booted from 'cdrom'", :lookup_method => lambda { %w|true false| }, :default_value => 'false'

param! "disk_size", "disk size in GB for the new VM"
param "sparse", "value for the 'sparse' parameter; influences virtual disk handling, see libvirt documentation", :default_value => 'false'
param "extra_disk", "relative image name and disk size in GB, separated by comma, for extra volumes to be created", :allows_multiple_values => true

param "vnc_password", "password for VNC access to the installation. if not set, VNC is disabled"
param "vnc_listen", "ipaddress on which VNC should listen for connections"

param "os_variant", "...", :default_value => 'virtio26'
param "os_type", "...", :default_value => 'linux'

param "http_proxy", "if specified, the http proxy is used for the installation and configured on the new machine"

notifications 

as_root do |machine, params|
  image_dir = "/var/lib/libvirt/images"
  image_path = "#{image_dir}/#{params["vm_name"]}.img"
  
  command = "virt-install --name #{params["vm_name"]} --ram #{params["memory_size"]} --vcpus=#{params["vcpu_count"]}" +
            " --accelerate --os-variant #{params["os_variant"]} --os-type=#{params["os_type"]}"
  
  if params.has_key?("http_proxy")
    command = "http_proxy=#{params["http_proxy"]} #{command}"
  end
    
  unless params['bridge']
    if @plugin.config.has_key?('default_bridge')
      params['bridge'] = @plugin.config['default_bridge']
    end
  end
  command += if params['bridge']
    " --network bridge:#{params["bridge"]}"
  else
    " --network network=default,model=virtio"
  end
  
  # if there's no bridge, we might want to use libvirt's DHCP
  # so we only auto-pick an IP if there'S a bridge
  if params['bridge']
    unless params.has_key?('ip')
      params["ip"] = machine.next_free_ip
      parts = params["ip"].split("\.")[0..2]
      parts << '1'
      params['gateway'] = parts.join(".")
    end 
  end
  
  if params['kickstart_url']
    ks_url = params['kickstart_url'] + '?'

    %w|ip gateway nameserver netmask|.each do |k|
      next unless params.has_key? k
      ks_url += "&" unless /\?$/.match(ks_url)
      ks_url += "#{k}=#{params[k]}"
      params['extra_arg'] << "#{k}=#{params[k]}"
    end
    
    ks_url += "&hostname=#{params["vm_name"]}"
    
    params['extra_arg'] << 'netmask=255.255.255.0'
    params['extra_arg'] << "dns=#{params['nameserver']}" if params['nameserver']
    params['extra_arg'] += [ "ks=#{ks_url}" ]
  end

  if params.has_key?('location')
    command += " --location #{params["location"]}"
    if params.has_key?('extra_arg')
      command += " --extra-args=\"" 
      params['extra_arg'].each do |extra_arg|
        command += " #{extra_arg}"
      end
      command += "\""
    end
  end
  
  if params.has_key?('cdrom')
    command += " --cdrom #{params['cdrom']}"
  end
  
  if params.has_key?('livecd') and params['livecd'] == 'true'
    command += ' --livecd --nodisks'    
  else
    command += " --disk path=#{image_path},size=#{params["disk_size"]},sparse=#{params["sparse"]},cache=none"
    
    if params.has_key?('extra_disk')
      params['extra_disk'].each do |disk_string|
        image_name, size = disk_string.split(',')
        command += " --disk path=#{image_dir}/#{image_name},size=#{size},sparse=#{params["sparse"]},cache=none"
      end
    end
  end
  
  if params.has_key?("vnc_password")
    command += " --graphics vnc,password=#{params["vnc_password"]}"
  elsif params.has_key?('vnc_listen')
    command += " --graphics vnc,listen=#{params['vnc_listen']}"
  else
    command += " --nographics"
  end
  command += " --noautoconsole"
  
  machine.ssh command
  
  # ugly little side-effect: record this installation (e.g. for the iptables generator)
  dir_name = "/var/lib/virtualop/machines"
  machine.hash_to_file(
    "file_name" => "#{dir_name}/#{params["vm_name"]}", 
    "content" => params
  )
  
  @op.without_cache do
    machine.list_installed_vms
  end
end