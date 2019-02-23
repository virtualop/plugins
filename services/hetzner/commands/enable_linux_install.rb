param! :machine

param "dist", default: "Ubuntu 18.04.1 LTS minimal"
param "arch", default: 64

param "lang", default: "en"

param "ssh_key", description: "fingerprints of SSH keys that should be authorized to login",
  multi: true, default: []

run do |machine, dist, arch, lang, ssh_key|
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
    lang: lang,
    authorized_key: ssh_key
  }
  request.set_form_data(post_data)

  data = account.hetzner_http("http_request" => request)
  unless data.has_key?("linux")
    raise "unexpected response - no key 'linux' found"
  end
  data["linux"]
end
