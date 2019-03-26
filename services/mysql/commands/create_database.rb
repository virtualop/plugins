param! :machine
param! "name", default_param: true

run do |machine, name|
  machine.mysql_exec("create database #{name}")
end
