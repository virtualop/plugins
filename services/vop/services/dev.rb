icon "vop_16px.png"
process_regex [ /vop.sh/, /puma/, /sidekiq/ ]

outgoing tcp: 22

database path: "web/db/development.sqlite3"

local_files path: "/etc/vop", alias: "config"

deploy package: %w|ruby ruby-dev ruby-bundler| +
                %w|build-essential| +
                %w|redis-server openssh-server|

# web dependencies
deploy package: %w|libsqlite3-dev zlib1g-dev nodejs|

param "domain"
param! "service_root", default: "virtualop"
param "vop_user", default: "marvin"

deploy do |machine, params|
  vop_user = params["vop_user"]
  base_dir = params["service_root"]
  $logger.info "installing vop.dev into #{base_dir}"

  # checkout from github
  %w|vop plugins web|.each do |repo|
    path = "#{base_dir}/#{repo}"
    machine.deploy_from_github(
      "github_project" => "virtualop/#{repo}",
      "dir" => path
    ) unless machine.file_exists(path)
  end

  vop_root = "#{base_dir}/vop"
  web_root = "#{base_dir}/web"

  # bundle install for vop and web
  [ vop_root, web_root ].each do |path|
    machine.ssh "cd #{path} && bundle install"
  end

  # web needs database migrations
  machine.ssh "cd #{web_root} && bundle exec rake db:migrate"

  # systemd services for web, sidekiq and message-pump
  machine.write_systemd_config(
    "name" => "vop-web",
    "user" => vop_user,
    "exec_start" => "#{base_dir}/web/bin/web.sh",
    "after" => "redis.service"
  )

  machine.write_systemd_config(
    "name" => "vop-background",
    "user" => vop_user,
    "exec_start" => "#{base_dir}/vop/bin/sidekiq.sh",
    "after" => "redis.service"
  )

  machine.write_systemd_config(
    "name" => "vop-message-pump",
    "user" => vop_user,
    "exec_start" => "#{base_dir}/web/bin/message-pump.sh",
    "after" => "redis.service"
  )

  %w|vop-web vop-background vop-message-pump|.each do |name|
    machine.enable_systemd_service name
    machine.start_systemd_service name
  end

  # apache as reverse proxy in front
  machine.install_service("apache.reverse_proxy")

  cable_domain = nil
  if params["domain"]
    machine.add_reverse_proxy(
      server_name: params["domain"],
      target_url: "http://localhost:3000/"
    )
    machine.parent.reverse_proxy.add_reverse_proxy(
      server_name: params["domain"],
      target_url: "http://#{machine.internal_ip}/"
    )

    cable_domain = "cable.#{params["domain"]}"
    machine.add_reverse_proxy(
      server_name: cable_domain,
      target_url: "ws://localhost:3000/cable/"
    )
    machine.parent.reverse_proxy.add_reverse_proxy(
      server_name: cable_domain,
      target_url: "ws://#{machine.internal_ip}/cable/"
    )
  end

  machine.vop_init(
    "vop_domain" => params["domain"],
    "cable_domain" => cable_domain,
    "vop_user" => vop_user
  )
end
