param :machine, '', :default_value => 'self'
param! 'path', 'service root of the webapp', :default_value => '/usr/lib/virtualop/webapp' 

on_machine do |machine, params|
  # TODO lets rather do this
  #machine.install_service_from_directory(
  #  'directory' => params['path'],
  #  'service' => 'virtualop_webapp', 
  #  'extra_params' => {
  #    'without_packages' => 'github'
  #  }
  #)
  
  service_root = params['path']
  
  machine.mkdir "#{service_root}/log"
  
  machine.install_canned_service 'my_sql'
  
  machine.create_database 'vop_logging'
  
  @op.configure 'slogans'
  
  machine.rvm_ssh "cd #{service_root} && bundle install"
  [ 'create', 'migrate' ].each do |task|
    machine.rvm_ssh "cd #{service_root} && rake db:#{task}"
  end
  
end