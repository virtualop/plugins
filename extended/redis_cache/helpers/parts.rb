def reconstruct_entities(cache_wrapper)
  result = cache_wrapper.data

  origin_class = cache_wrapper.options["origin"]
  (main, child) = origin_class.split("/")

  if child == "Vop::Entity"
    inflated = result.map do |entity_data|
      Entity.from_json(@op, entity_data)
    end
    result = ::Vop::Entities.new(inflated)
  end
  result
end

def prepare_for_cache(fresh_result)
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

  CacheWrapper.new(cache_data, {"origin" => origin_class})
end
