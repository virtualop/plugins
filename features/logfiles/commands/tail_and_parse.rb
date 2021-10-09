param! :machine
param! :log

param "count", default: 25

dont_log

run do |machine, log, count|
  data = machine.tail(path: log.path, count: count)
  @op.parse(machine: machine.name, log: log.path, data: data)
end
