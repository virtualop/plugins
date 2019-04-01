param! :machine

run do |machine|
  result = nil
  parts = machine.name.split(".")
  if parts.size == 3
    parent_name = parts[1..-1].join(".")
    result = @op.machines[parent_name]
  end
  result
end
