description "parses the output of 'free', as used by the 'memory' command"

param! "input"

run do |input|
  result = []

  #                total        used        free      shared  buff/cache   available
  # Mem:           7919        3556        2541          49        1821        4415
  # Swap:          1906           0        1906
  input.lines.each_with_index do |line, idx|
    $logger.debug "line ##{idx}: #{line}"
    if idx > 0
      matched = /(\w+)\:\s+([\d\s]+)/.match(line)
      if matched
        (total, used, free, shared, buffer, available) = matched.captures[1].split

        row = {
          "area" => matched.captures[0],
          "total" => total,
          "used" => used,
          "free" => free,
          "available" => available,
          "shared" => shared,
          "buffer" => buffer
        }
        begin
          full = (used.to_f / (total.to_f / 100)).round(2)
          row["full"] = full
        rescue => e
          $logger.error "could not calculate 'full' capacity for line #{idx} : #{e.message}"
          $logger.debug "row : #{row.pretty_inspect}"
        end

        known = %w|Mem Swap|
        if known.include? matched.captures[0]
          result << row
        end
      end
    end
  end

  result
end
