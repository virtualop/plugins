param! :machine
param! "package", multi: true, default_param: true

run do |machine, package|
  packages = package.join(" ")
  machine.sudo "DEBIAN_FRONTEND=noninteractive apt-get install -y #{packages}"
end
