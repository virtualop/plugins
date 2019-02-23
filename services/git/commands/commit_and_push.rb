description "commits changes in all tracked files and pushes the changes to the default remote repository"

param! :machine
param! "working_copy"
param! "comment", "description of the changes"

run do |machine, working_copy, comment|
  machine.commit_changes(working_copy: working_copy, comment: comment)
  machine.push_working_copy(working_copy: working_copy)
end
