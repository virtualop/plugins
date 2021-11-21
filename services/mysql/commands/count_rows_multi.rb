param! :machine
param! :database

run do |machine, database|
  tables = database.list_tables
  statement = tables.map do |table|
    "select count(1) as count_#{table} from #{table}"
  end.join(";\n")
  counts = database.run_sql(statement).split("\n")
  tables.zip(counts).to_h
end
