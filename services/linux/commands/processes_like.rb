param! :machine
param! "regex", default_param: true

show columns: %w|pid command|

run do |machine, regex|
  the_regex = /#{Regexp.escape(regex)}/
  machine.processes!.select do |process|
    the_regex.match(process["command"])
  end
end
