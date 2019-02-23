description "adds a name-based virtual host that acts as reverse proxy (forwarding incoming traffic to a remote backend)"

param! :machine
param! "server_name",
  description: "the http domain served by this vhost",
  default_param: true, multi: true
param! "target_url",
  description: "http url to the backend",
  multi: true
param "port",
  description: "the port number to serve on (80 or 443)",
  default: 80
param "timeout",
  description: "configuration for the ProxyTimeout directive - timeout in seconds to wait for a proxied response",
  default: 60

run do |plugin, machine, server_name, target_url, port, params|
  reverse_proxy_config = @op.read_template(
    template: plugin.template_path("reverse.proxy.conf.erb"),
    vars: {
      "target_urls" => target_url,
      "proxy_timeout" => params["timeout"]
    }
  )

  machine.add_vhost(
    server_name: server_name,
    port: port,
    vhost_config: reverse_proxy_config
  )
end
