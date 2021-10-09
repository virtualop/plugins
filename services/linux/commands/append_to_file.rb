description "appends content to a file (without locking, be careful)"

param! :machine
param! "file_name", "the target file to append content to. will be created if it doesn't exist."
param! "content", "the content to add to the file"

run do |machine, file_name, content|
  old_content = machine.file_exists(file_name) ?
    machine.read_file(file_name) : nil

  new_content = [ old_content, content ].compact.join("\n")

  machine.write_file("file_name" => file_name, "content" => new_content)
end
