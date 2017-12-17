param! :machine
param! "dir", default_param: true

run do |machine, dir|
  machine.ssh("mkdir -p #{dir}")
end
