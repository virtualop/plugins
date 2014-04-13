param :current_user

execute do |params|
  user = params['current_user']
  raise 'no user?' unless user
  
  domain = config_string('domain')
  "#{user}.#{domain}"
end  
  