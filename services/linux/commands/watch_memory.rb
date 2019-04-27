param! :machine
param! "count", default: 60

run do |plugin, machine, count|
  redis = plugin.state[:redis]

  # result = machine.ssh_call(
  #   "command" => "free -m",
  #   "dont_loop" => true,
  #   "request_pty" => true,
  #   "on_data" => lambda { |c, data|
  #     puts "got data : #{data}"
  #     parsed = @op.parse_memory(data)
  #
  #     redis.publish("memory_updates", {
  #       "machine" => machine.name,
  #       "content" => parsed
  #     }.to_json())
  #   },
  #   "on_stderr" => lambda { |c, data| puts data }
  # )
  # result["connection"].loop

  1.upto(count) do
    input = machine.ssh("free -m")
    parsed = @op.parse_memory(input)

    redis.publish("memory_updates", {
      "machine" => machine.name,
      "content" => parsed
    }.to_json())

    sleep 1
  end
end
