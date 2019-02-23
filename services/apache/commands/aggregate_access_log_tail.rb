param! :machine

param "interval", lookup: lambda { %w|minute hour day week| }, default: "hour"
param "count"

run do |machine, interval, count|
  parsed = machine.tail_and_parse_access_log(count: count)
  @op.aggregate_logdata(data: parsed, interval: interval)
end
