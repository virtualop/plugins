param! :machine

param! "server_name",
  description: "the http domain served by this vhost",
  default_param: true, multi: true

contribute to: "publish" do |machine, params|
  params.merge!({
    "machine" => machine.parent.reverse_proxy.name,
    "target_url" => "http://#{machine.internal_ip}/"
  })
  @op.add_reverse_proxy(params)
end
