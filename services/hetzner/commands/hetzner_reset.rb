param! :machine

param "reset_type", default: "sw"

run do |machine|
  server_ip = machine.metadata["server_ip"]
  unless server_ip
    raise "no server IP found for #{machine.name}"
  end

  account_alias = machine.metadata["account"]
  unless account_alias
    raise "no hetzner account found in metadata"
  end

  account = @op.hetzner_accounts[account_alias]
  raise "no account named '#{account_alias}'" unless account

  url = "/reset/#{server_ip}"
  request = Net::HTTP::Post.new(url)
  post_data = {
    type: reset_type,
  }
  request.set_form_data(post_data)

  account.hetzner_http("http_request" => request)
end
