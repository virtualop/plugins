param! :machine

run do |machine|
  parent_name = machine.name.split(".")[1..-1].join(".")
  @op.machines[parent_name]
end
