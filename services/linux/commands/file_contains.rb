param! :machine
param! "path"
param! "content"

run do |machine, path, content|
  result = machine.ssh_extended("grep -ie '#{content}' #{path}")
  result["result_code"].to_i == 0
end
