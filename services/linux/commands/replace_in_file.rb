description "calls 'sed' to replace a pattern in a file. see man sed"

param :machine
param! "file_name", "the file to work with"
param! "source", "the source pattern that should be replaced"
param! "target", "the replacement string"
param "sudo", default: false

run do |machine, params, sudo|
  source = params["source"].gsub('/', '\/')
  target = params["target"].gsub('/', '\/')
  sed_cmd = "sed -i -e 's/#{source}/#{target}/g' #{params["file_name"]}"
  if sudo
    machine.sudo sed_cmd
  else
    machine.ssh sed_cmd
  end
  # TODO this hangs when sudo=true
  unless sudo
    machine.read_file! params["file_name"]
  end
end
