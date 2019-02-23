param! :machine
param! "domain", multi: true, default_param: true

run do |plugin, machine, domain|
  certbot_email = plugin.config["eff_email"]
  if certbot_email.nil?
    raise "missing configuration key 'eff_email'"
  end

  certbot_bin = "certbot"  

  domain.each do |d|
    certbot_cmd = "#{certbot_bin} --non-interactive -m #{certbot_email} --agree-tos --eff-email"
    certbot_cmd += " --apache -d #{d}"
    machine.sudo(certbot_cmd)
  end

  # invalidate
  machine.list_files! "/etc/apache2/sites-enabled"
  machine.list_files! "/etc/apache2/sites-available"
end
