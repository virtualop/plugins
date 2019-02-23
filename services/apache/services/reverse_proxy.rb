# TODO inherit from: "apache.apache"
# (or: depend on: "apache.apache" ?)

# disabled because we don't want duplicate apache service markers in the map
#process_regex /httpd/
#process_regex /apache2/

port tcp: 80
#icon "apache_16px.png"

deploy package: ["apache2"]

# --- reverse proxy specific ---

deploy do |machine|
  machine.sudo "a2enmod proxy proxy_balancer proxy_http"
  machine.sudo "a2enmod proxy_wstunnel"
end
