param! :machine
param! "working_copy", "path to a working copy"

param "count", default: 3, description: "number of row that should be returned"

run do |machine, working_copy, count|
  input = machine.ssh "cd #{working_copy} && git log -#{count} --pretty=oneline"
  input.lines.map do |line|
    revision, *title = line.split
    {
      revision: revision,
      title: title.join(" ")
    }
  end
end
