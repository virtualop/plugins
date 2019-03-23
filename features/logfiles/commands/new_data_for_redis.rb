param! :machine
param! "file"
param! "data"

dont_log

run do |plugin, machine, file, data|
  redis = plugin.state[:redis]

  parsed = @op.parse(machine: machine.name, log: file, data: data)
  redis.publish("tail", {
    "machine" => machine.name,
    "log" => file,
    "content" => parsed
  }.to_json())

  aggregated = @op.aggregate(data: parsed, interval: "minute")
  redis.publish("graph", {
    "machine" => machine.name,
    "log" => file,
    "content" => aggregated
  }.to_json())

  aggregated
end
