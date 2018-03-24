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

  request = Net::HTTP::Get.new("/boot/#{server_ip}/linux")
  data = []
  begin
    data = account.hetzner_http("http_request" => request)
  rescue => e
    $logger.warn("problem fetching boot options for server #{machine.name} : #{e.message}")
  end

  unless data.has_key?("linux")
    raise "unexpected response - no key 'linux' found"
  end
  data["linux"]
end
