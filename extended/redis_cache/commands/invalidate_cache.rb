param! "command"
param! "raw_params", default: {}

run do |params, plugin|
  redis = plugin.state[:redis]

  request = Request.new(@op, params["command"], params["raw_params"])
  $logger.debug "invalidating #{request.cache_key}"

  count = redis.del request.cache_key
  $logger.debug "removed #{count} key(s) from cache : #{request.cache_key}"

  command = @op.commands[params["command"]]
  raise "no such command #{params["command"]}" if command.nil?

  if command.invalidation_block
    $logger.debug "calling custom invalidation block for #{command.name}"

    block_param_names = command.invalidation_block.parameters.map { |x| x.last }
    payload = @op.executor.prepare_payload(request, {}, block_param_names)

    command.invalidation_block.call(*payload)
  end

  count
end
