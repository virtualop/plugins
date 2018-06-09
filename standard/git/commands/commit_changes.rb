description "commits changes in all tracked files"

param! :machine
param! "working_copy"
param! "comment", "description of the changes"

run do |machine, working_copy, comment|
  machine.ssh "cd #{working_copy} && git commit -a -m '#{comment}'"

  machine.git_status! working_copy: working_copy
end
