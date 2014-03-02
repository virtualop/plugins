param :machine, '', :default_value => 'self', :mandatory => false
param 'path', 'service root of the webapp', :default_value => '/usr/lib/virtualop/webapp'
param 'domain', 'the domain at which the vop webinterface should be available', 
  :default_value => 'localhost', :default_param => true 

on_machine do |machine, params|
  # TODO lets rather do this
  #machine.install_service_from_directory(
  #  'directory' => params['path'],
  #  'service' => 'virtualop_webapp', 
  #  'extra_params' => {
  #    'without_packages' => [ 'github' ]
  #  }
  #)
  
  service_root = params['path']
  
  machine.mkdir "#{service_root}/log"
  
  machine.install_canned_service 'my_sql/my_sql'
  
  unless machine.list_databases.pick('name').include? 'vop_logging'
    machine.create_database 'vop_logging'
  end
  
  if params['db_type'] == 'mysql'
    @op.mysql_config(params)
  else
    @op.sqlite_config(params)
  end
  
  @op.configure 'slogans'
  
  machine.rvm_ssh "cd #{service_root} && bundle install"
  [ 'create', 'migrate' ].each do |task|
    machine.rvm_ssh "cd #{service_root} && rake db:#{task}"
  end
  
  machine.install_service_from_directory(
    'directory' => service_root,
    'service' => 'thin',
    'extra_params' => {
      'domain' => params['domain']
    }
  )
  
  #machine.change_runlevel 'running'
  machine.start_service('service' => 'apache/apache')
end