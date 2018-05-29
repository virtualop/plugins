description "returns a list of files that have been changed inside a working copy"

param! :machine
param! "working_copy"

read_only

run do |machine, working_copy|
  machine.ssh("cd #{working_copy} && git status --porcelain").lines.map do |line|
    matched = /(.{2})(.+)/ =~ line
    { "status" => case $1
        when " M"
          "modified"
        when "??"
          "untracked"
        else
          $1
        end,
      "path" => $2
    }
  end
end
