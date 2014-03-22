description "try to find the user's dev machine"

param :current_user

execute do |params|
  user = params['current_user']
  raise 'no user?' unless user
  
  dev_name = "dev_#{user}"
  # TODO needs rails_vop
  user_machine = @op.list_rails_machines.select { |x| 
    /^#{dev_name}/ =~ x['name'] 
  }.first
  
  unless user_machine
    raise "could not find dev machine for user #{user} - looked for #{dev_name}"  
  end
  $logger.info "auto-selecting #{user_machine['name']}"
  user_machine['name']
end  