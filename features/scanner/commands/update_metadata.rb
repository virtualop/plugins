param! :machine
param! "new_data", default_param: true

run do |plugin, params, machine, new_data|
  redis = plugin.state[:redis]
  cache_key = "vop.machine.#{params["machine"]}"

  meta = machine.metadata
  meta.merge! new_data
  redis.set(cache_key, meta.to_json)
end
