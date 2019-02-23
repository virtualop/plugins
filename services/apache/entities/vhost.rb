key "name"

on :machine

show columns: [ "name", "enabled" ]

invalidate do |machine|
  # TODO entity params should be auto-resolved
  machine = @op.machines[machine]

  machine.enabled_vhosts!
  machine.available_vhosts!
end

entity do |machine|
  machine = @op.machines[machine]

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
  result.each do |vhost|
    vhost.merge! machine.parse_vhost_config(
      "/etc/apache2/sites-available/#{vhost["name"]}"
    )
  end

  result
end
