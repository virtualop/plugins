param! :machine
param "internal_prefix", default: "192.168"

run do |machine, internal_prefix|
  unless internal_prefix.end_with? "."
    internal_prefix += "."
  end
  escaped_prefix = internal_prefix.gsub!(".", "\\.")

  # TODO make ipv4 vs ipv6 configurable
  input = machine.ssh("ip addr | grep -v '#{internal_prefix}' | grep inet | grep -v inet6 | grep -v '127.0.0.1'")
  if input =~ /inet\s+([\d\.]+)(?:\/(\d+))?/
    $1
  end
end
