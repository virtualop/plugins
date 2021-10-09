param! :machine

run do |plugin, machine|
  redis = plugin.state[:redis]
  cache_key = "vop.scan_result.#{machine.name}"
  json = redis.get(cache_key)
  json ? JSON.parse(json) : {}
end
