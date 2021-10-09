deploy do |machine|
  machine.sudo "snap install core"
  machine.sudo "snap refresh core"
  machine.sudo "snap install --classic certbot"

  machine.sudo "ln -s /snap/bin/certbot /usr/bin/certbot" unless machine.file_exists "/usr/bin/certbot"
end

binary_name "certbot"
icon "letsencrypt_16px.png"
