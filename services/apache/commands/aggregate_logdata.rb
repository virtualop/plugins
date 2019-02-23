param! "data", "the parsed entries to aggregate (array of hashes)", multi: true

param "interval", lookup: lambda { %w|minute hour day week| }, default: "hour"

run do |data, interval|
  raw = {}

  $logger.info("target interval : #{interval}")

  data.each do |entry|
    if entry.nil?
      $logger.warn("null entry while aggregating logdata")
    else
      adjusted_timestamp = entry[:timestamp_unix].to_i
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
      #$logger.debug "adjusted : #{timestamp} -> #{adjusted_timestamp}"

      selector = if entry[:status]
        entry[:status].to_i < 400 ? :success : :failure
      else
        :unknown
      end

      raw[selector] = {} unless raw.has_key? selector
      hash = raw[selector]

      hash[adjusted_timestamp] = [] unless hash.has_key? adjusted_timestamp
      hash[adjusted_timestamp] << entry
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

  raw[:success].keys.sort.each do |ts|
    bucket = raw[:success][ts]
    total = 0
    count = 0
    bucket.each do |entry|
      if entry[:response_time_microsecs]
        count += 1
        total += entry[:response_time_microsecs].to_i / 1000
      end
    end

    if count > 0
      avg = total / count
      aggregated[:response_time_ms] ||= []
      aggregated[:response_time_ms] << [
        ts, avg
      ]
    end
  end unless raw[:success] == nil

  aggregated
end
