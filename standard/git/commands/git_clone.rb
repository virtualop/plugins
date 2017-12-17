param! :machine
param! "url", default_param: true
param "dir"

run do |machine, url, dir|
  machine.ssh("git clone #{url} #{dir}")
end
