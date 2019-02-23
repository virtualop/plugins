param! :machine
param! "server_name", default_param: true, multi: true
param "vhost_config", default: ""
param "port", default: 80

run do |plugin, machine, server_name, vhost_config, port|
  # write apache config
  port_unless_80 = port != 80 ? "_#{port}" : ""
  config_name = "#{server_name.first}#{port_unless_80}"
  available_path = "/etc/apache2/sites-available/#{config_name}.conf"

  vars = {
    "server_names" => server_name,
    "port" => port
  }
  machine.write_template(
    template: File.join(plugin.plugin_dir(:templates), "vhost.conf.erb"),
    to: available_path,
    bind: OpenStruct.new(vars).instance_eval { binding }
  )

  # remove default template
  if machine.file_exists "/etc/apache2/sites-enabled/000-default.conf"
    machine.sudo "unlink /etc/apache2/sites-enabled/000-default.conf"
  end

  # enable vhost
  unless machine.file_exists "/etc/apache2/sites-enabled/#{config_name}.conf"
    machine.sudo "ln -s #{available_path} /etc/apache2/sites-enabled/"
  end

  # invalidate
  machine.vhosts!
  machine.read_file! file: available_path

  machine.sudo("service apache2 restart")
end
