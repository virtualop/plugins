param! :machine

param "count"

show columns: %w|remote_ip timestamp request status|

run do |machine, count|
  @op.parse_access_log(machine.tail_access_log(count: count))
end
