param! :machine
param! :database

run do |machine, database|
  database.list_tables.map do |table|
    count = database.run_sql("select count(1) as the_count from #{table}")
    {
      name: table,
      count: count.chomp
    }
  end
end
