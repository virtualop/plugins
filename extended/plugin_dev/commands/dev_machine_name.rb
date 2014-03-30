param 'suffix', 'string to append to "dev_<user>_" to build the new machine name'
param :current_user

mark_as_read_only

execute do |params|
  suffix = params['suffix'] ? "_#{params['suffix']}" : ''
  
  user = params['current_user']
  raise 'no user?' unless user
   
  "dev_#{user}" + suffix
end