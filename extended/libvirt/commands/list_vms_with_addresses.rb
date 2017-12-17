param! :machine

run do |machine|
  machine.list_vms.map do |vm|
    puts "vm : #{vm["name"]}"
    vm["address"] = machine.vm_address("name" => vm["name"])
    vm
  end
end
