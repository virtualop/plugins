require 'base64'

description "fetches data for a github object"

github_params
param! "blob_url"

#mark_as_read_only

display_type :blob

execute do |params|
  token = has_github(params) ? "access_token=#{params["github_token"]}" : ''
  result = JSON.parse @op.http_get("url" => "#{params["blob_url"]}?#{token}")
  Base64.decode64 result["content"]
end
