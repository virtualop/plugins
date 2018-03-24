param! "plugin_name"

run do |params|
  plugin = @op.plugin(params["plugin_name"])
  plugin.config
end
