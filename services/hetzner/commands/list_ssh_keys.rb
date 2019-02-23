param! :hetzner_account

show display_type: :raw

run do |hetzner_account|
  request = Net::HTTP::Get.new("/key")

  data = []
  begin
    data = hetzner_account.hetzner_http("http_request" => request)
  rescue => e
    $logger.warn("problem listing SSH keys: #{e.message}")
  end

  data
end
