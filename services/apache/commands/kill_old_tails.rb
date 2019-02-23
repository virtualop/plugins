param! :machine

run do |machine|
  candidates = machine.processes_like("tail").select do |process|
    file_name = "/var/log/apache2/access.log"
    process["command"] =~ /tail -f -n0 #{file_name}/ &&
    process["command"] !~ /sudo/
  end

  candidates.each do |moriturus|    
    machine.sudo "kill #{moriturus["pid"]}"
  end
end
