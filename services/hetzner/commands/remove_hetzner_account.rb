param! "alias"

run do |params, plugin|
  the_alias = params["alias"]

  unless plugin.config["accounts"].nil?
    plugin.config["accounts"].delete_if do |account|
      account["alias"] == the_alias
    end
  end

  @op.hetzner_accounts!
end
