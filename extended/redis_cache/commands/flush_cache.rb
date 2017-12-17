run do |plugin|
  redis = plugin.state[:redis]

  redis.flushall
end
