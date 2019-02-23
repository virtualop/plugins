param! :machine
param! "working_copy", description: "path to a working copy"

read_only

run do |machine, working_copy|
  machine.git_log("working_copy" => working_copy, "count" => 1).first
end
