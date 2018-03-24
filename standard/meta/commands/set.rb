param! "plugin"
param! "key"
param! "value"

run do |key, value, params|
  plugin = @op.plugin(params["plugin"])

  plugin.config[key] = value
  plugin.write_config

  plugin.config
end
