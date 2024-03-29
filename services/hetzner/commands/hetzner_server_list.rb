param! :hetzner_account

run do |hetzner_account|
  request = Net::HTTP::Get.new("/server")

  data = []
  begin
    data = hetzner_account.hetzner_http("http_request" => request)
  rescue => e
    $logger.warn("problem fetching hetzner server list: #{e.message}")
  end

  result = []
  data.each do |row|
    if row.has_key? "server"
      result << row["server"].tap do |x|
        x["type"] = "host"
        x["name"] = "#{x["server_name"]}.#{hetzner_account["alias"]}"
        x["account"] = hetzner_account["alias"]
      end
    end
  end
  result
end
