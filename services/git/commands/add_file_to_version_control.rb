description "registers a new file to the version control system so that it may be tracked from now on ever after"

param! :machine
param! "working_copy"
param! "file_name", description: "the file that should be added", multi: true

run do |machine, working_copy, file_name|
  machine.ssh "cd #{working_copy} && git add #{file_name.join(" ")}"

  machine.git_status! working_copy: working_copy
end
