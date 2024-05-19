param! :machine

run do |machine|
  vms = machine.list_vms
  machine.list_spares.map do |vm_name|
    vm = vms.select { |x| x["name"] == vm_name }.first
    if vm.nil?
      raise "sanity check failed : vm #{vm_name} nil"
    end

    vm_running = vm["state"] == "running"
    ssh_ok = @op.test_ssh("machine" => "#{vm_name}.#{machine.name}")
    installation_status = @op.installation_status(host_name: machine.name, vm_name: vm_name)
    # allow other vop installations to re-use spares without shared redis
    installation_finished = installation_status == "installed" || installation_status == nil

    usable = vm_running && installation_finished && ssh_ok

    usable ? vm_name : nil
  end.compact
end
