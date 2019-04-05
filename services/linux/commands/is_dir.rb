param! :machine
param! "path"

run do |machine, path|
  machine.list_files("-d #{path}").first["extra"] == "d"
end
