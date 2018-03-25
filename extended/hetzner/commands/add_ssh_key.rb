param! :hetzner_account
param! "name"
param! "key"


run do |hetzner_account, name, key|
  request = Net::HTTP::Post.new("/key")
  post_data = {
    name: name,
    data: key
  }
  request.set_form_data(post_data)

  data = []
  begin
    data = hetzner_account.hetzner_http("http_request" => request)
  rescue => e
    $logger.warn("problem adding SSH key: #{e.message}")
  end

  data
end
