param! :machine
param! "dir", default_param: true
param "permissions"

run do |machine, dir, params|
  unless machine.file_exists dir
    @op.mkdirs(params)
  end
end
