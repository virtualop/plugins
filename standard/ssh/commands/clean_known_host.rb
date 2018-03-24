param! "ip"

run do |ip|
  # TODO validate ip ?
  localhost = @op.machines["localhost"]

  home = localhost.ssh('echo $HOME').chomp
  known_hosts = File.join(home, ".ssh", "known_hosts")
  
  localhost.ssh "ssh-keygen -f #{known_hosts} -R #{ip}"
end
