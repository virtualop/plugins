param! :machine

read_only

run do |machine, plugin|
  procs = machine.processes.map { |x| x["command"] }

  result = []
  plugin.state[:services].each do |service|
    if service.data.has_key? :process_regex
      service.data[:process_regex].each do |regex|
        found = procs.grep regex
        if found.size > 0
          result << service.name
        end
      end
    end
  end

  result
end
