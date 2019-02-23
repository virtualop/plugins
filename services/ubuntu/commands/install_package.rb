param! :machine
param! "package", multi: true, default_param: true

run do |machine, package|
  packages = package.join(" ")
  machine.sudo "apt-get install -y #{packages}"
end
