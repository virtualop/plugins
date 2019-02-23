param! :machine
param! "file"

param "count", default: 25

param "sudo", default: false, description: "should sudo be used to call tail?"

run do |plugin, machine, file, count, sudo|
  redis = plugin.state[:redis]
  count = count ? "-n#{count}" : ""

  tail_command = "tail -f #{count} #{file}"
  if sudo
    tail_command = "sudo #{tail_command}"
  end
  result = machine.ssh_call(
    "command" => tail_command,
    "dont_loop" => true,
    "on_data" => lambda { |c, data|
      parsed = @op.parse_access_log(data.split("\n"))
      redis.publish("tail", {
        "machine" => machine.name,
        "log" => file,
        "content" => parsed
      }.to_json())

      aggregated = @op.aggregate_logdata(data: parsed, interval: "minute")
      graph = @op.prepare_graph(graph: aggregated)      
      redis.publish("graph", {
        "machine" => machine.name,
        "log" => file,
        "content" => graph
      }.to_json())
    },
    "on_stderr" => lambda { |c, data| puts data }
  )
  result["connection"].loop
end
