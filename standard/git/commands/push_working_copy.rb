param! :machine
param! "working_copy"
param "branch", default: "master"

run do |machine, working_copy, branch|
  # TODO auto-detect active branch (see 0.2)
  machine.ssh "cd #{working_copy} && git push origin #{branch}"
end
