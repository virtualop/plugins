param! :machine
param! "working_copy"

run do |machine, working_copy|
  machine.ssh "cd #{working_copy} && git stash apply"

  machine.git_status!("working_copy" => working_copy)
end
