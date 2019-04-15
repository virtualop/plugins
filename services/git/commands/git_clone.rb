param! :machine
param! "url", default_param: true
param "dir", default_param: "."

run do |machine, url, dir|
  if dir.nil?
    dir = project_name_from_git_url(url)
  end

  machine.ssh("git clone #{url} #{dir}")

  dir
end
