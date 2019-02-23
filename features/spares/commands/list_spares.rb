param! :machine

run do |machine|
  machine.list_vms.map { |vm| vm["name"] }.select do |vm_name|
    vm_name =~ /^spare/
  end
end
