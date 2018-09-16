read_only

contribute to: "machines" do |plugin|
  redis = plugin.state[:redis]

  names = redis.lrange(machine_list_key(), 0, -1)
  names.map do |name|
    { "name" => name }
  end
end
