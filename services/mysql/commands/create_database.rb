param! :machine
param! "name", default_param: true

run do |machine, name|
  existing = machine.databases.map(&:name)
  unless existing.include? name
    machine.mysql_exec("create database #{name}")
    machine.databases!
  end
end
