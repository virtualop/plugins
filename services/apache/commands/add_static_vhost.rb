param! :machine
param! "server_name",
  description: "the http domain served by this vhost",
  default_param: true,
  multi: true
param! "web_root"

run do |machine, server_name, web_root, plugin|
  static_vhost_config = @op.read_template(
    template: File.join(plugin.plugin_dir(:templates), "static.conf.erb"),
    vars: {
      "document_root" => web_root
    }
  )

  machine.add_vhost(
    server_name: server_name,
    vhost_config: static_vhost_config
  )  
end
