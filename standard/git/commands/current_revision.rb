param! :machine
param! "working_copy", "path to a working copy"

run do |machine, working_copy|
  machine.git_log("working_copy" => working_copy, "count" => 1).first
end
