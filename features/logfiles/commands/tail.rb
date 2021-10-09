param! :machine
param! "path"

param "count", default: 25

dont_log

run do |machine, path, count|
  count = count ? "-n#{count} " : ""
  # TODO we probably do not always need sudo
  machine.sudo("tail #{count}#{path}").split("\n")
end
