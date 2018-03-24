param! :machine
param! "sort_column"
param "count", default: 10

show sort: false

run do |machine, sort_column, count|
  result = ssh_regex(machine, "ps -eo pid,args,%cpu,%mem --sort -#{sort_column}",
    # PID         COMMAND  %CPU      %MEM
    # 2572        ng       60.4      12.1
    /^\s*(\d+)\s+(.+)\s+([\d\.]+)\s+([\d\.]+)$/,
    %w|pid command cpu mem|
  )

  # TODO would be nifty to auto-detect numbers (then we wouldn't have to .to_i here)
  count = count.to_i
  if count > 0
    last_idx = count -1
    result = result[0..last_idx]
  end

  result
end
