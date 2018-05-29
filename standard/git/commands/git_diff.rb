description "calls git diff to get a delta of the local changes"

param! :machine
param! "working_copy"

param "path_fragment", description: "a path fragment (relative to the working copy) that is passed on to 'git diff'", default: ""

run do |machine, working_copy, path_fragment|
  machine.ssh "cd #{working_copy} && git diff #{path_fragment}"
end
