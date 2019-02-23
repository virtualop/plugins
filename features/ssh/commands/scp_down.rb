param! :machine
param! "remote_path"
param! "local_path"

run do |machine, remote_path, local_path|
  ssh = machine.ssh_connection(force: true, dont_cache: true)
  $logger.debug "[#{machine.name}] scp #{remote_path} -> #{local_path}"
  ssh.scp.download! remote_path, local_path
end
