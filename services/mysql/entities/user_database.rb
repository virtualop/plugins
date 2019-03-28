description "returns a list of databases added by the user (as opposed to system databases)"

on :machine

entity do |machine|
  machine = @op.machines[machine]
  default_blacklist = %w|mysql information_schema performance_schema|
  machine.databases.select do |database|
    not default_blacklist.include? database.name
  end.map(&:data)
end
