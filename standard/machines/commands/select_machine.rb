param! 'machine_name'

run do |context, machine_name|
  context['machine'] = machine_name
  context['prompt'] = "#{machine_name} >> "
  true
end
