param! 'machine_name', :lookup => lambda { |params| @op.list_machines.map { |x| x[:name] }}

run do |context, machine_name|
  context['machine'] = machine_name
  context['prompt'] = "#{machine_name} >> "
  true
end
