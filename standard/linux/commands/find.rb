param! :machine
param! "path", default_param: true

run do |machine, path|
  machine.ssh "find #{path}"
end
