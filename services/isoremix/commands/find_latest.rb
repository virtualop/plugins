param! :machine

param! "iso_regex", "a regular expression to filter ISO names against"

run do |machine, iso_regex|
  iso_regex = Regexp.new(iso_regex)

  found = machine.list_rebuilt_isos.select do |iso|
    iso["name"] =~ iso_regex
  end
  unless found && found.size > 0
    raise "no rebuilt ISO found matching name pattern #{iso_regex}"
  end
  iso_name = found.sort_by { |x| x["timestamp"] }.last["name"]

  iso_name
end
