param! :machine

run do |machine|
  machine.mysql_exec("SELECT Host, User, Password FROM mysql.user").split("\n").map do |line|
    line.chomp!
    host, user, password = line.split
    user
  end
end
