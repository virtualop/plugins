param! :machine
param! "file", default_param: true

read_only

run do |machine, file|
  if file.nil? || file == ""
    raise "no file name"
  end
  machine.ssh "cat #{file}"
end
