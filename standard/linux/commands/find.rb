param! 'machine'
param! 'path'
param 'type', :default => 'f'
param 'name'
param 'maxdepth'

run do |machine, path, params|
  path += "/" unless /\/$/ =~ path
  find_command = "find #{path}"
  find_command += " -maxdepth #{params["maxdepth"]}" if params["maxdepth"]
  find_command += " -type #{params["type"]}" if params["type"]
  find_command += " -name #{params["name"]}" if params["name"]
  puts find_command
  machine.ssh(find_command).split("\n")
end
