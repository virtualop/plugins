param! :machine

run do |machine|
  result = []

  input = machine.ssh "command" => "sudo virsh pool-list", "request_pty" => true
  input.lines[2..-1].each do |line|
    line.strip!
    next if line.empty?

    (name, state, autostart) = line.strip.split
    result << {
      "name" => name,
      "state" => state,
      "autostart" => autostart
    }
  end

  result
end
