require "open-uri"
require "json"

show :columns => ["time", "plugin_name", "server_name", "short_title"]

run do
  scout_url = "https://scoutapp.com/api/v2/#{scoutapp_api_key}/alerts.json"
  response = open(scout_url).read
  parsed = JSON.parse(response)
  parsed["result"].map do |alert|
    alert["short_title"] = alert["title"][0..25]
    alert
  end
end
