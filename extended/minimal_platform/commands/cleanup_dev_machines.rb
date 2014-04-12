description "when a user account is deleted, the DNS records need to be cleaned up"

contributes_to :user_deleted_async

param! 'login'

accept_extra_params

execute do |params|
  user = params['login']
  raise 'no user?' unless user
  
  @op.list_rails_machines.select do |x| 
    x['environment'] &&
    x['environment'] == 'development' &&
    x['owner'] == user &&  
    /^#{@op.dev_machine_name('current_user' => user)}/ =~ x['name']
  end.each do |dev_machine|
    @op.comment "auto-cleaning up dev machine #{dev_machine['name']}"
  end
end