param :machine
param "device"
param "filter"

show columns: [ :address, :netmask ]

run do |machine, params|
  dev_filter = params.has_key?("device") ? "show #{params["device"]}" : ''

  result = []
  lines = machine.sudo("ip addr #{dev_filter}").split("\n")
  lines.each do |line|
    line.chomp! and line.strip!
    # TODO handle inet6
    next unless matched = /inet\s([\d\.]+)(?:\/(\d+))?/.match(line)
    result << {
      "address" => $1,
      "netmask" => $2
    }
  end
  result
end
