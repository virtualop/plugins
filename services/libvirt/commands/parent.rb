param! :machine

run do |machine|
  parts = machine.name.split(".")
  if parts.size < 3
    raise "the machine name consists of two parts only - are you sure that you're not on a host?"
  end
  parent_name = parts[1..-1].join(".")
  @op.machines[parent_name]
end
