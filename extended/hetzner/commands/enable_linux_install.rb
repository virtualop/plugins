param! :machine

param "dist", default: "Ubuntu 17.04 minimal"
param "arch", default: 64

param "lang", default: "en"

run do |machine, dist, arch, params|
  server_ip = machine.metadata["server_ip"]
  unless server_ip
    raise "no server IP found for #{machine.name}"
  end

  account_alias = machine.metadata["account"]
  unless account_alias
    raise "no hetzner account found in metadata"
  end
  $logger.info "activating hetzner reinstall configuration for #{server_ip} [#{account_alias}]"

  account = @op.hetzner_accounts[account_alias]
  raise "no account named '#{account_alias}'" unless account

  url = "/boot/#{server_ip}/linux"
  request = Net::HTTP::Post.new(url)
  post_data = {
    dist: dist,
    arch: arch,
    lang: "en"
  }
  request.set_form_data(post_data)

  data = account.hetzner_http("http_request" => request)
  unless data.has_key?("linux")
    raise "unexpected response - no key 'linux' found"
  end
  data["linux"]
end
