param! :machine
param! "path"
param "action", default: "install"

run do |machine, path, action|
  gem_file = "#{path}/Gemfile"
  if machine.file_exists(gem_file)
    machine.ssh "cd #{path} && bundle #{action}"
  else
    $logger.info "no Gemfile found in #{path}, not calling 'bundle #{action}'"
  end
end
