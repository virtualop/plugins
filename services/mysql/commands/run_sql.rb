param! :machine
param :database

param! "command_string", default_param: true

run do |machine, command_string, database|
  machine.mysql_exec(
    database: (database.name if database),
    command_string: command_string
  )
end
