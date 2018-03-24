require "time"
require "redis"

param! "machines", multi: true

show display_type: :hash

run do |machines, plugin|
  scanned = @op.collect_contributions(
    "command_name" => "machines_found",
    "raw_params" => { "machines" => machines }
  )

  redis = plugin.state[:redis]

  MACHINE_LIST = "vop.machines"
  #redis.ltrim(MACHINE_LIST, 1, 0) # empty
  known = redis.lrange(MACHINE_LIST, 0, -1)

  begin
    machines.each do |machine_row|
      machine_name = machine_row["name"]
      cache_key = "vop.machine.#{machine_name}"
      redis.set(cache_key, machine_row.to_json)

      unless known.include? machine_name
        redis.rpush(MACHINE_LIST, machine_name)
      end
    end
  ensure
    @op.redis_machines!
  end

  {}
end
