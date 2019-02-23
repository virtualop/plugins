#show columns: %w|alias username|

key "alias"

entity do |plugin|
  # TODO [security] the account data is stored in plain text
  $logger.debug "hetzner_account plugin: #{plugin.name}"
  plugin.config["accounts"] || []
end
