param! :machine
param! "file"

param "count", default: 25

param "sudo", default: false, description: "should sudo be used to call tail?"

run do |machine, file, count, sudo|
  count = count ? "-n#{count} " : ""

  options = "#{count}"

  tail_command = "tail #{options} #{file}"
  output = if sudo
    machine.sudo(tail_command)
  else
    machine.ssh(tail_command)
  end
  output.split("\n")
end
