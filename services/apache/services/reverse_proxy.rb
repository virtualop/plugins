deploy service: "apache.apache"

# --- reverse proxy specific ---

deploy do |machine|
  machine.sudo "a2enmod proxy proxy_balancer proxy_http"
  machine.sudo "a2enmod proxy_wstunnel"
  machine.sudo "a2enmod headers"
end
