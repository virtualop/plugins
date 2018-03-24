read_only

contribute to: "machines" do |plugin|
  redis = plugin.state[:redis]

  MACHINE_LIST = "vop.machines"
  names = redis.lrange(MACHINE_LIST, 0, -1)
  names.map do |name|
    { "name" => name }
  end
end
