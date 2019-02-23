deploy do |machine|
  machine.install_package "software-properties-common"
  machine.install_repo "ppa:certbot/certbot"
  machine.install_package "python-certbot-apache"
end

binary_name "certbot"
icon "letsencrypt_16px.png"
