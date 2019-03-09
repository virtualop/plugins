param! :machine
param "script", default: nil

run do |plugin, machine, script|
  script ||= plugin.config["script_name"]
  $logger.info "applying generated iptables script #{script} on #{machine.name}"

  generator_path = plugin.config["generator_path"]
  machine.ssh "#{generator_path}/#{script}"

  $logger.info("post iptables connection test: #{machine.hostname}")
end
