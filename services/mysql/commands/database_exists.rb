param! :machine
param! "name"

run do |machine, name|
  machine.databases.map(&:name).include? name
end
