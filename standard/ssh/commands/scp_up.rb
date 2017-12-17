param! :machine
param! "local_path"
param! "remote_path"

run do |machine, local_path, remote_path|
  ssh = machine.ssh_connection
  $logger.debug "[#{machine.name}] scp #{local_path} -> #{remote_path}"
  ssh.scp.upload! local_path, remote_path
end
