param! :machine
param! "path", default_param: true

run do |machine, path|
  machine.list_files("-d #{path}").first["extra"] == "d"
end
