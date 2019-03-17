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

  # post process: add SSL headers
  domain.each do |d|
    config = "/etc/apache2/sites-available/#{d}-le-ssl.conf"
    if machine.file_exists(config)
      file = machine.read_file!(config).split("\n")

      unless file.index "RequestHeader set X-Forwarded-Proto https"
        pos = file.index "ProxyPreserveHost On"
        file.insert pos + 1, "RequestHeader set X-Forwarded-Proto https"
        file.insert pos + 1, "RequestHeader set X-Forwarded-Ssl on"

        machine.write_file(
          file_name: config,
          sudo: true,
          content: file.join("\n")
        )
        machine.read_file! config
      end
    else
      $logger.warn("did not find config file #{config}, can not postprocess. #sad")
    end
  end
end
