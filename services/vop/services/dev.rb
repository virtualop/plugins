process_regex [ /vop.sh/, /puma/, /sidekiq/ ]

icon "vop_16px.png"

deploy package: %w|ruby ruby-dev ruby-bundler| +
                %w|build-essential| +
                %w|redis-server openssh-server|

# web dependencies
deploy package: %w|libsqlite3-dev zlib1g-dev nodejs|

param "domain"
param "base_dir", default: "virtualop"
param "vop_user", default: "marvin"

deploy do |machine, params|
  base_dir = params["base_dir"]
  unless base_dir.start_with? "/"
    base_dir = "#{machine.home}/#{base_dir}"
  end
  $logger.info "installing vop.dev into #{base_dir}"

  %w|vop plugins services web|.each do |repo|
    machine.deploy_from_github(
      "github_project" => "virtualop/#{repo}",
      "dir" => "#{base_dir}/#{repo}"
    )
  end

  [ "vop", "web" ].each do |repo|
    path = "#{base_dir}/#{repo}"
    machine.ssh "cd #{path} && bundle install"
  end

  machine.write_systemd_config(
    "name" => "vop-web",
    "user" => "marvin",
    "exec_start" => "#{base_dir}/web/bin/web.sh",
    "after" => "redis.service"
  )

  machine.write_systemd_config(
    "name" => "vop-background",
    "user" => "marvin",
    "exec_start" => "#{base_dir}/vop/bin/sidekiq.sh",
    "after" => "redis.service"
  )

  machine.write_systemd_config(
    "name" => "vop-message-pump",
    "user" => "marvin",
    "exec_start" => "#{base_dir}/web/bin/message-pump.sh",
    "after" => "redis.service"
  )

  %w|vop-web vop-background vop-message-pump|.each do |name|
    machine.enable_systemd_service name
    machine.start_systemd_service name
  end

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
    "vop_user" => params["vop_user"]
  )
end
