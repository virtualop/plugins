param! "machine"

run do |machine, plugin|
  redis = plugin.state[:redis]

  redis.lrem(machine_list_key(), 0, machine)

  @op.redis_machines!
end
