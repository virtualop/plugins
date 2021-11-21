on :machine

contribute to: "databases" do |machine|
  machine.mysql_exec("show databases").split("\n").map do |database_name|
    {
      "name" => database_name.chomp,
      "machine" => machine.name,
      "type" => "postgres"
    }
  end
end
