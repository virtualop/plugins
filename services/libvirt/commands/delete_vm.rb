param! :machine
param! "name", lookup: lambda { |params| @op.list_vms("machine" => params["machine"]).map { |x| x["name"] } }

run do |machine, name|
  vm_row = machine.list_vms.select { |x| x["name"] == name }.first
  raise "VM not found in list_vms" unless vm_row

  if vm_row["state"] == 'running'
    machine.stop_vm("name" => name)
  end

  # see https://bugzilla.redhat.com/show_bug.cgi?id=697742
  buggy_flag = "--managed-save"
  machine.sudo "command" => "virsh undefine #{name} #{buggy_flag}",
    "show_output" => true

  machine.list_vms!

  volume_name = "#{name}.img"
  found = machine.list_volumes.select { |v| v["name"] == volume_name }
  if found.size > 0
    $logger.debug "deleting volume #{volume_name}..."
    machine.sudo "command" => "virsh vol-delete --pool #{machine.default_pool} #{volume_name}",
      "show_output" => true
  end
end
