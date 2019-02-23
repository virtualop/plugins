param! :machine

read_only

run do |machine|
  result = []

  input = machine.ssh "systemctl list-unit-files --type=service"
  input.split("\n").each_with_index do |line, idx|
    # skip one header line
    next if idx == 0

    # stop at the first empty line
    break if line =~ /^$/

    parts = line.split
    result << {
      name: parts.first,
      state: parts.last
    }
  end
  result
end
