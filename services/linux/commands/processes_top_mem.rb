param! :machine
param "count", default: 10

show sort: false

run do |params|
  @op.processes_top(params.merge("sort_column" => "%mem"))
end
