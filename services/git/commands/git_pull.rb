param! :machine
param! "working_copy"

run do |machine, working_copy|
  # TODO handle branches
  machine.ssh "cd #{working_copy} && git pull origin master"

  machine.current_revision!("working_copy" => working_copy)
end
