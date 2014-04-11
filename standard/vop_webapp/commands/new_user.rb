param 'id'
param 'login'
param 'email'

accept_extra_params

with_contributions do |result, params|
  @op.comment "+++ new_user #{params['login']}"
  
  @op.execute_through_rabbit(
    'command_name' => 'new_user_async',
    'extra_params' => params.merge({'current_user' => 'marvin'}) 
  )
  
  result
end
