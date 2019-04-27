param! :machine

param "unit", description: "display unit (see man free)", default: "m"

run do |machine, unit|
  input = machine.ssh("free -#{unit}")
  @op.parse_memory(input)  
end
