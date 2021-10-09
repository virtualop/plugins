param! :machine, description: "parent virtualization host"
param! "name"

read_only

run do |machine, name|
  $logger.debug "reading IP address of VM #{name}"

  input = machine.ssh "bash -l -c 'virsh domifaddr #{name}'"

  most_lines = input.lines.select { |line| line !~ /Inappropriate ioctl for device/ }

  # compare headers vs. expectations
  header_line = most_lines.first
  headers = header_line.split
  expected = ["Name", "MAC", "address", "Protocol", "Address"]
  unless headers & expected == expected
    raise "unexpected headers : #{headers}\nexpected : #{expected}"
  end

  result = []
  data = most_lines[2..-1].each do |line|
    line.strip!
    next if line.empty?
    (name, mac, protocol, address) = line.strip.split
    result << {
      "name" => name,
      "mac_address" => mac,
      "protocol" => protocol,
      "address" => address.split("/").first
    }
  end
  result
end
