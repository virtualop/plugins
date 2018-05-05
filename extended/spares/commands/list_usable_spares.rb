param! :machine

run do |machine|
  vms = machine.list_vms
  machine.list_spares.map do |vm_name|
    vm = vms.select { |x| x["name"] == vm_name }.first
    if vm.nil?
      raise "sanity check failed : vm #{vm_name} nil"
    end
    vm["state"] == "running" &&
    @op.test_ssh("machine" => "#{vm_name}.#{machine.name}") ? vm_name : nil
  end.compact
end
