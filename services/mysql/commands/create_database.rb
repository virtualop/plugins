param! :machine
param! "name", default_param: true

run do |machine, name|
  existing = machine.databases.map(&:name)
  unless existing.include? name
    machine.mysql_exec("create database #{name}")
    # TODO : actually, we need to invalidate on mysql_database first
    machine.databases!
  end
end
