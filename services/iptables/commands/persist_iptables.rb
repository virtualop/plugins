param! :machine

run do |plugin, machine|
  generator_path = plugin.config["generator_path"]
  script_path = "#{generator_path}/iptables.sh"

  name = "iptables"
  machine.write_systemd_config(
    "name" => name,
    "exec_start" => script_path,
  )
  machine.enable_systemd_service name
  machine.start_systemd_service name
end
