param! :machine
param! "url", default_param: true

run do |machine, url|
  project_name = project_name_from_git_url(url)

  dir = "/var/www/#{project_name}"
  unless machine.file_exists(dir)
    # TODO the sudo should be hidden inside mkdir (or somewhere below)
    machine.sudo("mkdir #{dir}")
    # TODO hardcoded marvin
    machine.sudo("chown marvin:www-data #{dir}")
    machine.git_clone("url" => url, "dir" => dir)
  end

  dir
end
