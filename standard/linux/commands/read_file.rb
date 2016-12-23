param! :machine
param! "file"

run do |machine, file|
  machine.ssh("cat #{file}")
end
