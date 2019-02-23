param! :machine
param! "package", lookup: lambda { |params| @op.list_packages(params).map { |x| x["name"] } }

run do |machine, package|
  machine.ssh "dpkg -L #{package}"
end
