param :machine
param :current_user
param! 'new_owner'

execute do |params|
  # TODO check current owner
  
  m = Machine.find_by_name(params['machine'])
  m.owner = params['new_owner']
  m.save!
  
  "#{params['current_user']} changed owner of #{params['machine']} to #{params['new_owner']}"
end
