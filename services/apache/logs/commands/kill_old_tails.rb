param! :machine
param! "file"

run do |machine, file|
  candidates = machine.processes_like("tail").select do |process|
    process["command"] =~ /tail -f -n0 #{file}/ &&
    process["command"] !~ /sudo/
  end

  candidates.each do |moriturus|
    machine.sudo "kill #{moriturus["pid"]}"
  end
end
