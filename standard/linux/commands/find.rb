param! 'machine'
param! 'path'
param 'type'
param 'name'
param 'maxdepth'

run do |machine, path, params|
  path += "/" unless /\/$/ =~ path
  find_command = "find #{path}"
  find_command += " -maxdepth #{params["maxdepth"]}" if params.key? "maxdepth"
  find_command += " -type #{params["type"]}" if params.key? "type"
  find_command += " -name #{params["name"]}" if params.key? "name"
  $logger.debug find_command
  machine.ssh(find_command).split("\n")
end
