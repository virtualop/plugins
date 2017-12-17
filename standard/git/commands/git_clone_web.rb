param! :machine
param! "url", default_param: true

run do |machine, url|
  project_name = nil
  if /\/([^\/]+)\.git$/.match(url)
    project_name = $1
  end
  if project_name.nil?
    raise "could not determine project_name from Git URL: unexpected format #{url}"
  end

  dir = "/var/www/#{project_name}"
  unless machine.file_exists(dir)
    machine.sudo("mkdir #{dir}")
    # TODO hardcoded marvin
    machine.sudo("chown marvin:www-data #{dir}")
    machine.git_clone("url" => url, "dir" => dir)
  end

  dir
end
