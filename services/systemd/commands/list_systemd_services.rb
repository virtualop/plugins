param! :machine

read_only

run do |machine|
  result = []

  input = machine.ssh "systemctl list-unit-files --type=service"
  input.split("\n").each_with_index do |line, idx|
    next if idx == 0          # skip one header line
    break if line =~ /^$/     # stop at the first empty line

    parts = line.split
    result << {
      name: parts.first,
      state: parts.last
    }
  end

  result
end
