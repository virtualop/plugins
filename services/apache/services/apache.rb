process_regex /httpd/
process_regex /apache2/

port tcp: 80
icon "apache_16px.png"

deploy package: "apache2"
