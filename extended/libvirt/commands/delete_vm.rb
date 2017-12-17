param! :machine
param! "name", lookup: lambda { |params| @op.list_vms("machine" => params["machine"]).map { |x| x["name"] } }

run do |machine, name|
  vm_row = machine.list_vms.select { |x| x["name"] == name }.first
  raise "VM not found in list_vms" unless vm_row

  if vm_row["state"] == 'running'
    machine.stop_vm("name" => name)
  end

  #machine.maybe_sudo cmd: ". /etc/profile && virsh undefine #{name}"

  # see https://bugzilla.redhat.com/show_bug.cgi?id=697742
  buggy_flag = "--managed-save"
  machine.ssh "command" => "sudo virsh undefine #{name} #{buggy_flag}",
    "request_pty" => true, "show_output" => true

  @op.invalidate_cache(
    "command" => "list_vms",
    "raw_params" => machine.name
  )

  machine.list_vms

  pools = machine.list_pools.map { |x| x["name"] }
  pool = pools.include?("images") ? "images" : "default"

  # TODO maybe check first if the volume exists?
  machine.ssh "command" => "sudo virsh vol-delete --pool #{pool} #{name}.img",
    "request_pty" => true, "show_output" => true
end
