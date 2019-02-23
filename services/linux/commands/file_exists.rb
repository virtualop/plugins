param! :machine
param! "path", default_param: true

run do |machine, path|
  result = machine.ssh_extended("ls -1 #{path}")
  result["result_code"].to_i == 0
end
