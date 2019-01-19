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
      if child == "Vop::Entity"
      #if (main == "Array" || main == "Vop::Entities") && child == "Vop::Entity"
        inflated = cached.map do |entity_data|
          Entity.from_json(plugin.op, entity_data)
        end
        cached = ::Vop::Entities.new(inflated)
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

      # keep track of the data structure
      origin_class = fresh_result.class.to_s
      if fresh_result.is_a?(Array)
        origin_class += "/#{fresh_result.first.class.to_s}"
      end

      # prepare the data to cache
      cache_data = fresh_result
      if fresh_result.is_a?(::Vop::Entities)
        cache_data = fresh_result.map do |entity|
          entity.to_json()
        end
      end
      for_cache = CacheWrapper.new(cache_data, {"origin" => origin_class})

      json = nil
      begin
        # TODO filter sensitive data
        json = for_cache.to_json
        $logger.debug "caching for #{request.cache_key} (#{origin_class}) : #{json}"
        redis.set(request.cache_key, json)
      rescue => detail
        $logger.warn("could not cache #{request.cache_key} - response not serializable")
      end
      result = fresh_result
    end
    raise ::Vop::InterruptChain.new(response)
  else
    request.next_filter.execute(request)
  end
end
