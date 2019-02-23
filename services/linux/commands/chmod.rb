param! :machine
param! "file"
param! "permissions"

run do |machine, file, permissions|
  machine.ssh("chmod #{permissions} #{file}")
end
