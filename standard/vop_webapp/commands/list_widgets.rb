param :current_user

add_columns [ :name, :position ]

with_contributions do |result, params|
  puts "current user : #{params['current_user']}"
  
  result + [
    {
      'name' => 'machinez',
      'position' => 'main',
      'template' => @plugin.path + '/widgets/machinez.erb'
    },
    {
      'name' => 'vop_logging',
      'position' => 'north',
      'template' => "#{Rails.root.to_s}/app/views/home/widgets/_vop_logging.erb"
    },
    {
      'name' => 'machines',
      'position' => 'fix',
      'template' => "#{Rails.root.to_s}/app/views/home/widgets/_machines.erb"
    },
    {
      'name' => 'projects',
      'position' => 'fix',
      'template' => "#{Rails.root.to_s}/app/views/home/widgets/_projects.erb"
    }
  ]  
end
