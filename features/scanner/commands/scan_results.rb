param :machine, multi: true

run do |plugin, params, machine|
  machines = params[:machine] || @op.machines

  redis = plugin.state[:redis]
  names = machines.map(&:name)
  keys = names.map { |name| "vop.scan_result.#{name}" }
  results = redis.mget(*keys)
  results.each_with_index.map do |result, idx|
    parsed = JSON.parse(result) unless result.nil?
    [ names[idx], parsed || {} ]
  end.to_h
end
