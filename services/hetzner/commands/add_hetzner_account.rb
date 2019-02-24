param! "alias"
param! "username"
param! "password"

run do |plugin, params, username, password|
  the_alias = params["alias"]

  if plugin.config["accounts"].nil?
    plugin.config["accounts"] = []
  end

  plugin.config["accounts"] << {
    "alias" => the_alias,
    "username" => username,
    "password" => password
  }
  plugin.write_config

  @op.hetzner_accounts!
end
