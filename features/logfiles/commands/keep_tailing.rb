param! :machine
param! "file"

param "count", default: 25

param "sudo", default: false, description: "should sudo be used to call tail?"

run do |plugin, machine, file, count, sudo|
  count = count ? "-n#{count}" : ""
  prefix = sudo ? "sudo " : ""
  tail_command = "#{prefix} tail -f #{count} #{file}"

  result = machine.ssh_call(
    "command" => tail_command,
    "dont_loop" => true,
    "fresh_connection" => true, # TODO do we need this?
    "on_data" => lambda { |c, data|
      machine.new_data_for_redis(file: file, data: data.split("\n"))
    },
    "on_stderr" => lambda { |c, data| puts data }
  )
  result["connection"].loop
end
