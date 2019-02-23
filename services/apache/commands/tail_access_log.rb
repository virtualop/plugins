param :machine
param "count", default: 25

run do |machine, count|
  count = count ? "-n#{count} " : ""
  machine.sudo("tail #{count}/var/log/apache2/access.log").split("\n")
end
