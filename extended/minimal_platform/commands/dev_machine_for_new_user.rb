description "when a new user registers, a new development VM is created automatically"

contributes_to :new_user_async

param! 'login'

accept_extra_params

execute do |params|
  user = params['login']
  raise 'no user?' unless user
  
  @op.comment "dev machine for new user #{user}"
  
  machine_name = @op.prepare_dev_machine('current_user' => user)
  @op.comment @op.change_owner('machine' => machine_name, 'new_owner' => user)
  
  #user_domain = @op.user_domain('current_user' => user)
  #@op.install_canned_service('service' => 'hello_world/hello_world', 'extra_params' => { 'domain' => user_domain, 'user_name' => user })
end
