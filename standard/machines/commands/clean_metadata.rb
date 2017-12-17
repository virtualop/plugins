param! :machine

run do |machine, plugin|
  redis = plugin.state[:redis]

  cache_key = "vop.machine.#{machine.name}"
  redis.del(cache_key)
end
