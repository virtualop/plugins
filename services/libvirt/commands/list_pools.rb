param! :machine

run do |machine|
  result = []

  input = machine.sudo "virsh pool-list"
  input.lines[2..-1].each do |line|
    line.strip!
    next if line.empty?

    (name, state, autostart) = line.split
    result << {
      "name" => name,
      "state" => state,
      "autostart" => autostart
    }
  end

  result
end
