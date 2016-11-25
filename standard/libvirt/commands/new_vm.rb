param! 'machine'
param! 'name', :default_param => true

param 'memory_size'
param 'cpu_count'
param 'os_variant'
param 'os_type'
param 'location'
param 'cdrom'
param 'extra_args'
param 'disk_size'

param 'vnc_password'
param 'vnc_listen'

run do |params, name, machine|
  pp params

  memory_size ||= 512
  cpu_count ||= 1
  os_variant ||= 'virtio26'
  os_type ||= 'linux'
  disk_size ||= 25

  image_dir = "/var/lib/libvirt/images"
  image_path = "#{image_dir}/#{name}.img"

  command = "virt-install --name '#{name}' --ram #{memory_size} --vcpus=#{cpu_count}" +
            " --accelerate --os-variant=#{os_variant} --os-type=#{os_type}"

  command += " --disk path=#{image_path},size=#{disk_size},sparse=false,cache=none"

  if params.has_key?('cdrom')
    command += " --cdrom=#{params['cdrom']}"
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

  if params.has_key?("vnc_password")
    command += " --graphics vnc,password=#{params["vnc_password"]}"
  elsif params.has_key?("vnc_listen")
    command += " --graphics vnc,listen=#{params["vnc_listen"]}"
  else
    command += " --nographics"
  end
  command += " --noautoconsole"

  puts "command: >>#{command}<<"
  machine.ssh("command" => command, "user" => "root")

  command
end
