param! :machine
param! "name"

run do |machine, name|
  machine.stop_vm(name: name)
  machine.start_vm(name: name)
end
