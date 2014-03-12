contributes_to :notify_new_vm_stop_ok

param :machine

on_machine do |machine, params|
  machine.generate_and_execute_iptables_script
end
