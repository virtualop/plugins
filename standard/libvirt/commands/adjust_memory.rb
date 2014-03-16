description "changes the amount of memory assigned to this VM, involves a restart of the VM"

param :machine
param :vm
param! 'value', 'new memory size in MB'

on_machine do |machine, params|
  kb = params['value'].to_i * 1024
  
  machine.shutdown_and_wait('name' => params['name'])
  machine.set_maxmem('name' => params['name'], 'value' => kb)
  machine.start_vm('name' => params['name'])
  machine.set_mem('name' => params['name'], 'value' => kb)
  
  # TODO hardcoded naming convention
  full_name = params['name'] + '.' + params['machine']
  
  @op.wait('timeout' => 60, 'error_text' => 'could not connect to VM after startup') do
    @op.cache_bomb
    @op.reachable_through_ssh('machine' => full_name)
  end
  
  @op.cache_bomb
  meminfo = @op.meminfo('machine' => full_name)
  
  meminfo['MemTotal']
end
