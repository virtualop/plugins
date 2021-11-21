param! :machine
param! :database, use_context: false

run do |machine, database, context|
  context["database"] = database.name
  true
end
