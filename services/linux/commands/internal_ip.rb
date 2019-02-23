param! :machine
param "prefix", default: "192.168"

run do |machine, prefix|
  unless prefix.end_with? "."
    prefix += "."
  end
  escaped_prefix = prefix.gsub!(".", "\\.")
  # TODO we could have more than one internal IP, right?
  input = machine.ssh("ip addr | grep #{prefix}")
  if input =~ /inet\s+(#{prefix}\d+\.\d+)/
    $1
  end
end
