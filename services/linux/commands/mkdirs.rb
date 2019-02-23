param! :machine
param! "dir", default_param: true
param "permissions"

run do |machine, dir, permissions|
  command = "mkdir -p"
  if permissions
    command += " -m #{permissions}"
  end
  command += " #{dir}"
  machine.ssh(command)
end
