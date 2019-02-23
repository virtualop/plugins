param! :machine

run do |machine|
  ssh_regex(machine, "dpkg -l",
    /^(\w{2})\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+)$/,
    ["status", "name", "version", "architecture", "description"]
  )
end
