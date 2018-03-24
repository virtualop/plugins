param! "command"
param! "raw_params", default: {}

run do |params, plugin|
  redis = plugin.state[:redis]

  request = Request.new(@op, params["command"], params["raw_params"])
  $logger.debug "invalidating #{request.cache_key}"

  count = redis.del request.cache_key
  $logger.debug "removed #{count} key(s) from cache : #{request.cache_key}"

  count
end
