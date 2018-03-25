param! :hetzner_account
param! "http_request"

run do |hetzner_account, params|
  endpoint = "https://robot-ws.your-server.de"
  uri = URI.parse(endpoint)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  $logger.debug "hosts for account #{hetzner_account["alias"]}"

  request = params["http_request"]
  request.basic_auth(hetzner_account["username"], hetzner_account["password"])

  $logger.info "authenticating with user #{hetzner_account["username"]}"

  response = http.request(request)
  unless response.is_a? Net::HTTPOK
    raise "received HTTP code #{response.code} from #{uri} : #{response.message}"
  end

  json_response = response.body.strip
  JSON.parse(json_response)
end
