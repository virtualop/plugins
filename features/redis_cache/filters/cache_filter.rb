require_relative "../helpers/cache_wrapper"

run do |command, request, plugin|
  should_cache = command.read_only

  if should_cache
    redis = @op.plugin("redis_cache").state[:redis]
    raise "no redis connection" unless redis

    cached = nil
    cache_state = "miss"

    cache_wrapper = CacheWrapper.from_json redis.get(request.cache_key)
    if cache_wrapper
      cache_state = "hit"
      cached = reconstruct_entities(cache_wrapper)
    end

    $logger.debug "cache #{cache_state} : #{request.cache_key}"
    result = nil
    response = nil

    if cached.nil?
      response = request.next_filter.execute(request)
      fresh_result = response.result

      for_cache = prepare_for_cache(fresh_result)
      begin
        # TODO filter sensitive data
        $logger.debug "serializing to JSON : #{for_cache}"
        json = for_cache.to_json()
        $logger.debug "caching for #{request.cache_key} : #{json}"
        redis.set(request.cache_key, json)
      rescue => detail
        $logger.warn("could not cache #{request.cache_key} : #{detail.message}")
        $logger.debug for_cache.pretty_inspect
        $logger.debug json
      end
      result = fresh_result
    else
      result = cached

      timestamp = nil
      begin
        timestamp = Time.at(cache_wrapper.timestamp)
      rescue TypeError => detail
        $logger.error("cannot parse timestamp #{cache_wrapper.timestamp}")
      end
      response = Response.new(result, {}, timestamp)
    end
    raise ::Vop::InterruptChain.new(response)
  else
    request.next_filter.execute(request)
  end
end
