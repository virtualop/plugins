param! :machine
param! "path"

param "interval", lookup: lambda { %w|minute hour day week| }, default: "hour"
param "count"

run do |machine, path, interval, count|
  parsed = @op.tail_and_parse(machine: machine.name, log: path, count: count).compact
  @op.aggregate(data: parsed, interval: interval)
end
