param! :machine
param "interval", default: 2

run do |plugin, params, machine, interval|
  redis = plugin.state[:redis]

  interval = interval.to_i

  while true do
    input = machine.ssh("free -m")
    parsed = @op.parse_memory(input)

    redis.publish("memory_updates", {
      "machine" => machine.name,
      "content" => parsed
    }.to_json())

    sleep interval
  end
end
