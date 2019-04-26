param! :machine

param! "server_name",
  description: "the http domain served by this vhost",
  default_param: true, multi: true

run do |machine, params|
  @op.collect_contributions(
    command_name: "publish",
    raw_params: params
  )
end
