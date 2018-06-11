param! :machine
param! "working_copy"

run do |machine, working_copy|
  # TODO handle branches
  machine.ssh "cd #{working_copy} && git pull origin master"

  # TODO invalidate current_revision
end
