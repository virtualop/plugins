param! "service_root", default: "src"

deploy package: %w|build-essential git|
deploy package: %w|ruby ruby-dev ruby-bundler|

# the tests need Redis and SSH
deploy package: %w|redis-server openssh-server|

# web dependencies
deploy package: %w|libsqlite3-dev zlib1g-dev nodejs|

deploy do |machine, params|
  base_dir = params["service_root"]
  repos = %w|vop plugins web bundle|

  unless machine.file_contains("path" => "/etc/environment", "content" => "VOP_PATH")
    machine.append_to_file("file_name" => "/etc/environment", "content" => 'VOP_PATH="../vop"')
  end

  # checkout all repos and install dependencies
  repos.each do |repo|
    path = "#{base_dir}/#{repo}"

    # github checkout
    machine.git_clone(
      "url" => "https://github.com/virtualop/#{repo}.git",
      "dir" => path
    ) unless machine.file_exists(path)

    # bundle install
    machine.maybe_bundle(path)
  end
end
