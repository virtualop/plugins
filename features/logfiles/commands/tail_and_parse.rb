param! :machine
param! :log

param "count", default: 25

dont_log

run do |machine, log, count|
  count = count ? "-n#{count} " : ""
  data = machine.sudo("tail #{count}#{log.path}").split("\n")

  @op.parse(machine: machine.name, log: log.path, data: data)
end
