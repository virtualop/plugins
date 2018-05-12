param! :machine
param! "url", default_param: true
param "dir"

run do |machine, url, dir|
  project_name = project_name_from_git_url(url)

  if dir.nil?
    dir = project_name
  end

  unless machine.file_exists(dir)
    machine.ssh("git clone #{url} #{dir}")
  end

  dir
end
