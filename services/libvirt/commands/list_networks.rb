param! :machine

run do |machine|
  result = []

  input = machine.sudo "virsh net-list"
  input.lines[2..-1].each do |line|
    line.strip!
    next if line.empty?

    (name, state, autostart, persistent) = line.strip.split
    result << {
      "name" => name,
      "state" => state,
      "autostart" => autostart,
      "persistent" => persistent
    }
  end

  result
end
