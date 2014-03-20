param :hetzner_alias

#result_as :list_hetzner_accounts

execute do |params|
  @plugin.state[:hetzner_drop_dir].delete_local_dropdir_entry params["alias"]
  
  @op.cache_bomb
  @op.list_hetzner_accounts
end
