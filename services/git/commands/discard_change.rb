param! :machine
param! "working_copy"
param! "file_name", description: "the file that should be added", multi: true

run do |machine, working_copy, file_name|
  machine.ssh "cd #{working_copy} && git checkout -- #{file_name.join(" ")}"

  machine.git_status! working_copy: working_copy
end
