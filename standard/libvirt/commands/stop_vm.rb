param! "machine", :description => "the host machine on which the VM lives"
param! "name"

run do |machine, name|
  machine.ssh("virsh destroy #{name}")
end
