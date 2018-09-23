description "configures a machine to accept SSH connections from another machine (specifically the default user on that machine)"

param! :machine
param! "other_machine", lookup: lambda { @op.machines.map { |x| x.name } }

run do |machine, other_machine|
  other = @op.machines[other_machine]

  machine.add_authorized_key(other.read_public_key)
end
