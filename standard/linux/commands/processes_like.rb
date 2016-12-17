param! "machine"
param! "expression", :default_param => true

show columns: %i|pid command_short|

run do |params, expression|
  column_name = :command_short
  @op.processes(params).select do |item|
    item[column_name] =~ Regexp.new(expression)
  end
end
