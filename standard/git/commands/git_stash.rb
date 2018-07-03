param! :machine
param! "working_copy"

run do |machine, working_copy|
  machine.ssh "cd #{working_copy} && git stash save"

  machine.git_status!("working_copy" => working_copy)
end
