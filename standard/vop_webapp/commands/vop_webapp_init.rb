param :machine, '', :default_value => 'self', :mandatory => false
param "service_root", "fully qualified path to the location of the service", :default_value => '/usr/lib/virtualop/webapp' 
param 'domain', 'the domain at which the vop webinterface should be available', 
  :default_value => 'localhost', :default_param => true
param "db_type", "type of database to use for the rails app", :default_value => 'mysql',
  :lookup_method => lambda { %w|sqlite mysql| }   

on_machine do |machine, params|
  # TODO lets rather do this
  #machine.install_service_from_directory(
  #  'directory' => params['path'],
  #  'service' => 'virtualop_webapp', 
  #  'extra_params' => {
  #    'without_packages' => [ 'github' ]
  #  }
  #)
  
  service_root = params['service_root']
  
  machine.mkdir "#{service_root}/log"
  
  machine.install_canned_service 'my_sql/my_sql'
  
  @op.configure('plugin_name' => 'vop_webapp', 'extra_params' => { 'db_type' => 'mysql' })
  
  unless machine.list_databases.pick('name').include? 'vop_logging'
    machine.create_database 'vop_logging'
  end
  
  machine.load_plugin "#{service_root}/.vop/virtualop_webapp.plugin"
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
  
  machine.install_canned_service('rabbitmq/rabbitmq')
  machine.start_service('rabbit_mq/rabbitmq')

  @op.configure_rabbitmq_plugin('broker_enabled' => 'true')
  @op.configure_database_logging('db_host' => 'localhost', 'db_name' => 'vop_logging', 'db_user' => 'root')
  
  machine.install_service_from_directory('directory' => service_root, 'service' => 'launcher')
  machine.install_service_from_directory('directory' => service_root, 'service' => 'message_processor')
end
