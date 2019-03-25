param! "data", "the parsed entries to aggregate (array of hashes)", multi: true

param "interval", lookup: lambda { %w|minute hour day week| }, default: "hour"

dont_log

run do |data, interval|
  raw = {}

  $logger.info("aggregating #{data.size} rows using target interval : #{interval}")

  data.each do |entry|
    if entry.nil?
      $logger.warn("null entry while aggregating logdata")
    else
      adjusted_timestamp = entry[:timestamp].to_i
      timestamp = DateTime.parse(Time.at(adjusted_timestamp).to_s)
      if %w|minute hour day week|.include? interval
        adjusted_timestamp -= timestamp.sec
      end
      if %w|hour day week|.include? interval
        adjusted_timestamp -= timestamp.min * 60
      end
      if %w|week|.include? interval
        adjusted_timestamp -= timestamp.hour * 60 * 60
      end
      adjusted_timestamp = Time.at(adjusted_timestamp)
      $logger.debug "adjusted : #{timestamp} -> #{adjusted_timestamp}"

      selector = if entry[:return_code]
        entry[:return_code].to_i < 400 ? :success : :failure
      else
        :unknown
      end

      raw[selector] = {} unless raw.has_key? selector
      hash = raw[selector]

      key = adjusted_timestamp.to_i
      hash[key] = [] unless hash.has_key? key
      hash[key] << entry
    end
  end

  aggregated = {}

  raw.each do |selector, e|
    e.keys.sort.each do |bucket|
      aggregated[selector] = [] unless aggregated.has_key? selector
      aggregated[selector] << [
        bucket, e[bucket].size
      ]
    end
  end

  # TODO reactivate response_time_ms? (see aggregate_logdata)

  aggregated
end
