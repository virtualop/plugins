require "time"
require "redis"

param! "machines", multi: true

run do |machines|
  redis = Redis.new
  stats = Hash.new { |h,k| h[k] = 0 }

  machines.each do |machine_row|
    name = machine_row["name"]

    existing = Machine.find_by_name(name)
    if existing
      existing.seen_at = Time.now()
      existing.save
      stats[:existing] += 1
      $logger.debug "updating #{name}"
    else
      new_machine = Machine.create(name: name)
      stats[:new] += 1
      $logger.debug "new #{name}"
    end

    cache_key = "vop.machine.#{name}"
    redis.set(cache_key, machine_row.to_json)
  end

  stats
end
