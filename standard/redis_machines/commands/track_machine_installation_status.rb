param :machine
param! "status"

run do |plugin, machine, status|
  redis = plugin.state[:redis]

  cache_key = "vop.installation_status.#{machine.name}"
  redis.set(cache_key, status)

  redis = plugin.state[:redis]
  redis.publish("vm_installation_status", {
    "machine" => machine.name,
    "status" => status
  }.to_json())
end
