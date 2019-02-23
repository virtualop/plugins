param! :machine

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

  request = Net::HTTP::Get.new("/reset/#{server_ip}")
  data = []
  begin
    data = account.hetzner_http("http_request" => request)
  rescue => e
    $logger.warn("problem fetching reset status for server #{machine.name} : #{e.message}")
  end

  data
end
