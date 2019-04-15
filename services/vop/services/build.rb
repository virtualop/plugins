param! "service_root", default: "src"

deploy package: "build-essential"
deploy package: %w|ruby ruby-dev ruby-bundler|

# the tests need Redis and SSH
deploy package: %w|redis-server openssh-server|

# web dependencies
deploy package: %w|libsqlite3-dev zlib1g-dev nodejs|

deploy do |machine, params|
  base_dir = params["service_root"]
  repos = %w|vop plugins web bundle|
  repos.each do |repo|
    path = "#{base_dir}/#{repo}"

    # github checkout
    machine.git_clone_or_update(
      "url" => "https://github.com/virtualop/#{repo}.git",
      "dir" => path
    )

    # bundle install
    gem_file = "#{path}/Gemfile"
    if machine.file_exists(gem_file)
      machine.ssh "cd #{path} && bundle install"
    end
  end
end
