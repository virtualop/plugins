description "performs the base installation for a new machine"

param :machine
param "http_proxy", "if specified, the http proxy is used for the installation and configured on the new machine", 
  :default_value => config_string('http_proxy', '')

param :environment

ignore_extra_params

notifications

on_machine do |machine, params|
  machine.write_environment("environment" => params["environment"]) if params.has_key?("environment")
  
  if params.has_key?('http_proxy') and params['http_proxy'] != ''
    process_local_template(:http_proxy, machine, "/etc/profile.d/http_proxy.sh", binding())
  end 
  
  # TODO machine.append_to_file("file_name" => "/etc/hosts", "content" => "127.0.0.1 #{machine.name}")
  # TODO append "search #{domain_thing}" => "/etc/resolv.conf"
  
  if machine.distro == 'centos'
    machine.set_hostname("hostname" => machine.name.split('.').first)
    machine.install_rpm_package("name" => [ "git", "vim", "screen", "man" ])
    machine.write_own_centos_repo()
    machine.ssh("command" => "/etc/init.d/sshd restart")
    machine.ssh("command" => "sed -i -e 's!#PermitUserEnvironment no!PermitUserEnvironment yes!' /etc/ssh/sshd_config")
    
    # TODO we should not need this anymore at some point (disabling selinux in kickstart now), but we do need it
    @op.without_cache do
      machine.ssh("command" => "setenforce Permissive")
      machine.replace_in_file('file_name' => '/etc/selinux/config',
        'source' => 'SELINUX=enforcing',
        'target' => 'SELINUX=permissive'
      )
    end
  end  
  #machine.ssh("command" => "gem update --system")
    
  machine.mkdir('dir_name' => @op.plugin_by_name('service_descriptors').config_string('service_config_dir'))
  
  # TODO add public keys and deactivate password login

  # TODO seems this is not invalidated through the flush_cache() call above - not quite sure why, though    
  @op.without_cache do
    machine.list_services
  end
end
