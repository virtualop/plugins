param! :machine
param! "file"

read_only

run do |machine, file|
  machine.ssh "cat #{file}"
end
