param! :machine
param! "name"

run do |machine, name|
  full_name = machine.convert_spare("new_name" => name)
  vm = @op.machines[full_name]
  host = vm.parent
  host.vm_addresses!("name" => name)
end
