param! :machine
param! "content"

run do |machine, content|
  puts "write_tmp_file (#{content})"
  machine.write_file(file_name: "/tmp/async_test.log", content: content)
end
