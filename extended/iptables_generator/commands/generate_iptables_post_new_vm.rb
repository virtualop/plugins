#contributes_to :notify_new_vm_stop_ok
contributes_to :notify_setup_vm_stop_ok

accept_extra_params

execute do |params|
  machine_name = params["extra_params"]["result"]
  @op.generate_and_execute_iptables_script('machine' => machine_name)
end  
#on_machine do |machine, params|
#  machine.generate_and_execute_iptables_script
#end
