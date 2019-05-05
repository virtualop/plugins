param! "template"
param "vars", default: {}

run do |template, vars|
  renderer = ERB.new(IO.read(template))

  bind = binding
  vars.each do |k,v|
    bind.local_variable_set(k.to_sym, v)
  end
  
  renderer.result(bind)
end
