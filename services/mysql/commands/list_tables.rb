param! :machine
param! :database

run do |machine, database|
  database.run_sql("show tables").split("\n").map(&:chomp)
end
