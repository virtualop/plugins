param! "ip"

run do |ip|
  localhost = @op.machines["localhost"]

  known_hosts = File.join(localhost.home, ".ssh", "known_hosts")

  localhost.ssh "ssh-keygen -f #{known_hosts} -R #{ip}"
end
