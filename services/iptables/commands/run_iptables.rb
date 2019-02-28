param! :machine
param "script", default: "minimal_fw.sh"

run do |plugin, machine, script|
  $logger.info "applying generated iptables script #{script} on #{machine.name}"

  generator_path = plugin.config["generator_path"]
  machine.ssh "#{generator_path}/#{script}"

  $logger.info("post iptables connection test: #{machine.hostname}")
end
