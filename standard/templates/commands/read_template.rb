param! "template"
param "bind"
param "vars", default: {}

run do |template, vars|
  renderer = ERB.new(IO.read(template))
  bind = OpenStruct.new(vars).instance_eval { binding }
  renderer.result(bind)
end
