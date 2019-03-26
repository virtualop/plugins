param! :machine
param! "name"
param! "password"
param "host", default: "localhost"

run do |machine, name, password, host|
  machine.mysql_exec "create user '#{name}'@'#{host}' identified by '#{password}'"
end
