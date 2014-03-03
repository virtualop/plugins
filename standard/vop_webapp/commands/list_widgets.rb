param :current_user

add_columns [ :name, :position ]

with_contributions do |result, params|
  puts "current user : #{params['current_user']}"
  pp params['current_user']
  
  [
    {
      'name' => 'machinez',
      'position' => 'main',
      'template' => @plugin.path + '/widgets/machinez.erb'
    }
  ]  
end