require_relative "../helpers/cache_wrapper"

run do |command, request, plugin|
  should_cache = command.read_only

  if should_cache
    # TODO we need this workaround (to get the plugin) because the above "plugin" is the one for the command that's executed
    redis = @op.plugin("redis_cache").state[:redis]
    raise "no redis connection" unless redis

    cache_wrapper = CacheWrapper.from_json redis.get(request.cache_key)
    cached = nil
    if cache_wrapper
      cache_state = "hit"
      cached = cache_wrapper.data
      origin_class = cache_wrapper.options["origin"]
      (main, child) = origin_class.split("/")
      if main == "Array" && child == "Vop::Entity"
        cached.map! do |entity_data|
          Entity.json_create(plugin.op, entity_data)
        end
      end
    else
      cache_state = "miss"
    end
    $logger.debug "cache #{cache_state} : #{request.cache_key}"

    result = nil
    response = nil
    unless cached.nil?
      result = cached

      description = if result.respond_to? :size
        size_text = " "
        size_text += result.size.to_s
        size_text += if result.is_a? Array
          " lines"
        else
          " bytes (?)"
        end
        size_text
      else
        result
      end

      timestamp = nil
      begin
        timestamp = Time.at(cache_wrapper.timestamp)
      rescue TypeError => detail
        $logger.error("cannot parse timestamp #{cache_wrapper.timestamp}")
      end
      response = Response.new(result, {}, timestamp)
    else
      response = request.next_filter.execute(request)
      fresh_result = response.result
      context = response.context

      origin_class = fresh_result.class.to_s
      if fresh_result.is_a?(Array)
        origin_class += "/#{fresh_result.first.class.to_s}"
      end
      for_cache = CacheWrapper.new(fresh_result, {"origin" => origin_class})
      $logger.debug "caching for #{request.cache_key} (#{origin_class}) : #{for_cache.to_json}"
      # TODO filter sensitive data
      redis.set(request.cache_key, for_cache.to_json)
      result = fresh_result
    end
    raise ::Vop::InterruptChain.new(response)
  else
    request.next_filter.execute(request)
  end
end