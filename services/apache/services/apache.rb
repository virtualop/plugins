process_regex /httpd/
process_regex /apache2/

port tcp: 80
icon "apache_16px.png"

log_file "/var/log/apache2/access.vop.log",
  parser: "parse_access_vop_log"

deploy package: "apache2"

deploy template: "logformat.conf.erb",
  to: "/etc/apache2/conf-available/logformat-vop.conf"

deploy do |machine|
  machine.sudo "a2enconf logformat-vop"
end
