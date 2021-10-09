param! :machine

param! "server_name",
  description: "the http domain served by this vhost",
  default_param: true, multi: true

contribute to: "publish" do |machine, params|
  params.merge!({
    "target_url" => "http://#{machine.internal_ip}/"
    })
  proxy_vm = machine.parent.reverse_proxy
  proxy_vm.add_reverse_proxy(params)
  proxy_vm.letsencrypt params["server_name"]
end
