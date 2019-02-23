param! :machine

run do |machine|
  host = machine.parent
  host.delete_vm(name: machine.short_name)

  @op.machine_deleted(machine.name)
end
