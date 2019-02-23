description "commits changes in a working copy"

param! :machine
param! "working_copy"
param! "comment", "description of the changes"

param "file", multi: true, description: "can be used to specify which files to commit. defaults to all changes"

run do |params, machine, working_copy, comment, file|
  git_command = "git commit -m '#{comment}'"
  git_command += " " + if file.nil?
    "-a"
  else
    file.join(" ")
  end

  machine.ssh "cd #{working_copy} && #{git_command}"

  machine.current_revision! working_copy: working_copy
  machine.git_status! working_copy: working_copy
end
