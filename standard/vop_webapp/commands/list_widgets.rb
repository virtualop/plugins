param :current_user

add_columns [ :name, :position ]

with_contributions do |result, params|
  puts "current user : #{params['current_user']}"
  
  result += [
    {
      'name' => 'machinez',
      'position' => 'main',
      'template' => @plugin.path + '/widgets/machinez.erb'
    }
  ]
  
  result.sort_by { |x| x['file_name'] || '' }  
end
