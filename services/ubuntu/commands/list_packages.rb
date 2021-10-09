param! :machine

run do |machine|
  ssh_regex(machine, "dpkg -l",
    /^(\w{2})\s+(\S+?)(?:\:(?:\w+))?\s+(\S+)\s+(\S+)\s+(.+)$/,
    ["status", "name", "version", "architecture", "description"]
  )
end
