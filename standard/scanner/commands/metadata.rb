param! :machine

run do |params, plugin|
  redis = plugin.state[:redis]

  cache_key = "vop.machine.#{params["machine"]}"
  json = redis.get(cache_key)
  json ? JSON.parse(json) : {}
end
