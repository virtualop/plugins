param! "machine"

run do |plugin, machine|
  redis = plugin.state[:redis]

  # TODO this way of searching will not scale too well
  search = "vop/request*machine=#{machine}*"
  redis.keys(search).each do |key|
    redis.del key
  end
end
