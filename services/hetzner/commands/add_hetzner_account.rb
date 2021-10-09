param! "alias"
param! "username"
param! "password"

param "group"

run do |plugin, params, username, password, group|
  # +alias+ is a reserved name
  the_alias = params["alias"]

  if plugin.config["accounts"].nil?
    plugin.config["accounts"] = []
  end

  account_config = {
    "alias" => the_alias
  }.tap do |config|
    group = params["group"]
    config["group"] = group if group
  end

  plugin.config["accounts"] << account_config
  plugin.write_config

  auth_data = {
    username: username,
    password: password
  }
  @op.write_data_into_vault(path: "hetzner/account/#{the_alias}", data: auth_data)

  @op.hetzner_accounts!
end
