param! :machine, description: "parent virtualization host"
param! "name", default_param: true

run do |machine, name|
  addresses = machine.vm_addresses("name" => name)
  (addresses.first || {}).fetch("address", "")
end
