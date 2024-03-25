param! "machine"

run do |machine, plugin|
  redis = plugin.state[:redis]

  @op.collect_contributions(
    command_name: "machine_deleted",
    raw_params: {}
  )

  redis.lrem(machine_list_key(), 0, machine)

  @op.redis_machines!
  @op.machines!
end
