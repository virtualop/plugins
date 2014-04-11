param! 'login'

accept_extra_params

with_contributions do |result, params|
  @op.comment "+++ user_deleted #{params['login']}"
  
  @op.execute_through_rabbit(
    'command_name' => 'user_deleted_async',
    'extra_params' => params.merge({'current_user' => 'marvin'}) 
  )
end  

