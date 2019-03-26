param! :machine
param! :database

param! "command_string", default_param: true

run do |machine, database, command_string|
  machine.mysql_exec(
    database: database.name,
    command_string: command_string
  )
end
