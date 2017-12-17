param! :machine
param! "file_name"
param! "content"
param "sudo", default: false

run do |machine, file_name, content, sudo|
  write_cmd = if sudo    
    "| sudo tee #{file_name}"
  else
    "> #{file_name}"
  end
  machine.ssh "echo '#{content}' #{write_cmd}"
end
