param :machine

add_columns [ :time, :ip, :hostname ]

on_machine do |machine, params|
  #machine.read_file('/var/lib/libvirt/dnsmasq/default.leases')
  input = machine.ssh('cat /var/lib/libvirt/dnsmasq/default.leases')
  input.split("\n").map do |line|
    line.chomp!
    parts = line.split(' ')
    {
      'timestamp' => parts[0],
      'time' => Time.at(parts[0].to_i),
      'mac' => parts[1],
      'ip' => parts[2],
      'hostname' => parts[3],
      'raw' => line
    }    
  end
end
