description "returns a list of databases added by the user (as opposed to system databases)"

on :machine

entity do |machine|
  default_blacklist = %w|mysql information_schema performance_schema sys|
  machine.databases.select do |database|
    not default_blacklist.include? database.name
  end.map(&:data)
end

# TODO needs to be invalidated e.g. when a database is added via create_database or copy_remote_database
