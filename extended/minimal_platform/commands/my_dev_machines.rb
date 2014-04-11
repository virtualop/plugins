param :current_user

execute do |params|
  user = params['current_user']
  raise 'no user?' unless user
  
  @op.list_rails_machines.select { |x| 
    x['environment'] &&
    x['environment'] == 'development'
    x['owner'] == user  
  }
end