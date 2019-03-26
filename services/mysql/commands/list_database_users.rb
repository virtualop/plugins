param! :machine

run do |machine|
  machine.mysql_exec "SELECT Host, User, Password FROM mysql.user"
end
