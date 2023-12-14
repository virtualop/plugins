param! :machine
param! "command_string", default_param: true

param "database"

run do |machine, command_string, params|
  mysql_command = "sudo mysql --skip-column-names"
  database = params["database"]
  if database
    mysql_command += " -D#{database}"
  end
  machine.ssh(
    "request_pty" => true,
    "command" => "echo \"#{command_string}\" | #{mysql_command}"
  )
end
