description "reconfigures a virtualop webapp to run on mysql"

param :machine

on_machine do |machine, params|
  service_root = machine.service_details('virtualop_webapp/thin')['service_root'] 
  machine.install_canned_service 'my_sql/my_sql'
  machine.load_plugin "#{service_root}/.vop/virtualop_webapp.plugin"
  
  machine.mysql_config('service_root' => service_root)
  [ 'create', 'migrate' ].each do |task|
    machine.rvm_ssh "cd #{service_root} && rake db:#{task}"
  end
  machine.restart_service 'virtualop_webapp/thin'
end
