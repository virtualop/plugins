param! :machine
param! "working_copy"

run do |machine, working_copy|
  machine.ssh "cd #{working_copy} && git pull origin master"
end
