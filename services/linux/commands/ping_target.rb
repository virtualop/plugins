param! :machine
param! "target", default_param: true

param "count", default: 1

run do |machine, target, count|
  output = machine.ssh "ping -c#{count} #{target}"
  # last two lines:
  # 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  # rtt min/avg/max/mdev = 0.341/0.341/0.341/0.000 ms
  last2 = output.lines[-2..-1]

  result = {}
  matched = /(\d+)\s+packets transmitted,\s+(\d+)\s+received,\s+(\d+)% packet loss, time\s+(\d+)ms/.match(last2.first)
  if matched
    result["sent"] = matched.captures[0]
    result["received"] = matched.captures[1]
    result["loss"] = matched.captures[2]
    result["time"] = matched.captures[3]
  end

  result
end
