require "net/http"

def scoutapp_api_key
  ENV['SCOUTAPP_API_KEY']
end

def set_notifications(machine, new_state)
  scout_url = "https://scoutapp.com"

  uri = URI.parse(scout_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  # scoutapp uses short names to identify hosts:
  short_name = machine.name.split(".").first
  path = "/api/v2/#{scoutapp_api_key}/servers/#{short_name}"

  request = Net::HTTP::Post.new(path)
  request.body = "notifications=#{new_state}"

  response = http.request(request)
  response.is_a? Net::HTTPOK
end
