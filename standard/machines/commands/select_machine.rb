param! :machine, use_context: false

run do |machine, context|
  context["machine"] = machine.name
  context["prompt"] = "#{machine.name} >> "
  true
end
