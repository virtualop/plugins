param! :machine
param! "cmd"

run do |machine, cmd|
  raise "kaboom"
  maybe_sudo = machine.current_user == "root" ? "" : "sudo "
  machine.ssh "#{maybe_sudo}#{cmd}"
end
