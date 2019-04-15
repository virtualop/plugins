param! :machine
param! "url", default_param: true
param "dir", default_param: "."

run do |params, machine, url, dir|
  if machine.file_exists(dir)
    machine.git_pull(working_copy: dir)
  else
    @op.git_clone(params)
  end
end
