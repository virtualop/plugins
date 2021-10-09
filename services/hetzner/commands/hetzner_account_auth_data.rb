param! :hetzner_account

run do |hetzner_account|
  # TODO prefix with hosting_accounts or somesuch?
  vault_path = "hetzner/account/#{hetzner_account["alias"]}"
  @op.read_data_from_vault(vault_path)
end
