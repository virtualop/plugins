param! :machine

run do |machine|
  # TODO might need sudo
  input = machine.ssh("ss -tnlp")

  result = Hash.new { |h,k| h[k] = [] }

  # State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
  # LISTEN     0      128          *:111                      *:*
  input.split("\n")[1..-1].map do |line|
    (state, recvq, sendq, local, peer) = line.split()
    parts = local.split(':')
    (listen_address, listen_port) = parts[0..-2].join(':'), parts.last.to_i
    result[listen_port] << listen_address
  end

  result
end
