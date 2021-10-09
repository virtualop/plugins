key "name"

on :machine

show columns: [ "name", "enabled" ]

invalidate do |machine|
  machine.enabled_vhosts!
  machine.available_vhosts!
end

entity do |machine|
  # result is made up of enabled_vhosts
  result = machine.enabled_vhosts.map(&:data)

  # + available_hosts that are not also enabled
  enabled_names = result.map { |x| x["target"].split("/").last }
  machine.available_vhosts.each do |vhost|
    unless enabled_names.include? vhost["name"]
      result << {
        "name" => vhost["name"],
        "enabled" => false
      }
    end
  end

  # read vhost config
  result.map do |x|
    file_name = "/etc/apache2/sites-available/#{x["name"]}"
    vhost_config = machine.parse_vhost_config(file_name)
    x.merge(vhost_config)
  end
end
