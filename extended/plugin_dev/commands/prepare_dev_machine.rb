description "installs a development VM for a user"

param :current_user

param 'name', 'name for the new machine. disables +suffix+ if specified'
param 'suffix', 'string to append to "dev_<user>_" to build the new machine name'

param 'features', 'select which type of development should be prepared', :allows_multiple_values => true,
  :lookup_method => lambda { %w|owncloud github| },
  :default_value => [  ]
  
param 'service', 'a service that should be installed (url-encoded)',
  :allows_multiple_values => true,
  :default_value => []  
  
execute do |params|
  dev_machine = params['name'] || @op.dev_machine_name(params)
  
  full_name = @op.new_machine(
    'vm_name' => dev_machine,
    'environment' => 'development',
    'memory_size' => 1024 
  )
  @op.init_system_user('machine' => full_name, 'user' => 'marvin')
  @op.flush_cache
  
  @op.with_machine(full_name) do |m|
    m.as_user('marvin') do |machine|
      machine.generate_keypair
      machine.disable_ssh_key_check
      
      $logger.error "[BUG] machine.name seems to return the user context here : #{machine.name}"
      
      if params['features'].include?('github')
        machine.prepare_github_ssh_connection
        public_key = machine.read_file "#{machine.home}/.ssh/id_rsa.pub"
        @op.add_ssh_key('title' => full_name, 'key' => public_key)
      end
    
      if params['features'].include?('owncloud')
        marvin_user = "marvin_#{dev_machine}"
        marvin_password = config_string('marvin_dev_machine_pwd')
        
        unless @op.list_users.pick(:uid).include?(marvin_user)
          @op.add_user(
            'email' => 'marvin@virtualop.org',
            'first_name' => 'marvin',
            'last_name' => dev_machine,
            'username' => marvin_user,
            'password' => marvin_password
          )
        end
        
        machine.install_canned_service(
          'service' => 'owncloud_client/owncloud_client',
          'extra_params' => {
            'owncloud_domain' => config_string('owncloud_url'),
            'username' => marvin_user,
            'password' => marvin_password
          }
        )
      end
      
      machine.install('service' => params['service'])
    end
  end
  
  full_name
end
