param! :machine
param "pool"

run do |machine, pool|
  if pool.nil?
    pool = machine.default_pool
  end
  input = machine.sudo("virsh vol-list #{pool}")
  result = []
  input.lines.each_with_index do |line, idx|
    next if idx < 2
    text = line.chomp
    next if text.empty?
    (name, path) = text.split
    result << {
      "name" => name,
      "path" => path
    }
  end
  result
end
