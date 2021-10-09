require "net/http"

param! :hetzner_account
param! "http_request"

run do |hetzner_account, params|
  endpoint = "https://robot-ws.your-server.de"
  uri = URI.parse(endpoint)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  $logger.debug "hosts for account #{hetzner_account["alias"]}"

  auth_data = @op.hetzner_account_auth_data(hetzner_account: hetzner_account["alias"])
  request = params["http_request"]
  request.basic_auth(auth_data[:username], auth_data[:password])

  $logger.info "authenticating with user #{auth_data["username"]}"

  response = http.request(request)
  unless response.is_a?(Net::HTTPOK) || response.code == 201
    raise "received HTTP code #{response.code} from #{uri} : #{response.message}"
  end

  json_response = response.body.strip
  JSON.parse(json_response)
end
