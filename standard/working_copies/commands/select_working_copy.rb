param! :machine
param! 'working_copy'

run do |context, machine, params|
  context['working_copy'] = params["working_copy"]
  true
end
