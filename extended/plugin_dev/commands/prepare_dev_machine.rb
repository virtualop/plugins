description "installs a development VM for a user"

param "user", "the user to prepare the machine for"
param :current_user

execute do |params|
  user = params["user"]
  
  dev_machine = "dev_#{user}"
  
  marvin_user = "marvin_#{dev_machine}"
  marvin_password = config_string('marvin_dev_machine_pwd')
  unless @op.list_users.pick(:uid).include?(user)
    @op.add_user(
      'email' => 'marvin@virtualop.org',
      'first_name' => 'marvin',
      'last_name' => dev_machine,
      'username' => marvin_user,
      'password' => marvin_password
    )
  end
  
  full_name = @op.new_machine(
    'vm_name' => dev_machine,
    'environment' => 'development',
    'memory_size' => 1024, 
    'canned_service' => "owncloud_client/owncloud_client",
    'extra_params' => {
      'owncloud_domain' => config_string('owncloud_url'),
      'username' => marvin_user,
      'password' => marvin_password
    }
  )
  
  @op.with_machine(full_name) do |machine|
    machine.disable_ssh_key_check
    machine.upload_stored_keypair # TODO which one (or generate?)
  end
end
