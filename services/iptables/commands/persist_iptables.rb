param! :machine

run do |machine|
  script_source = "/var/lib/virtualop/iptables.d/minimal_fw.sh"

  name = "iptables"
  machine.write_systemd_config(
    "name" => name,
    "exec_start" => script_source,
  )
  machine.enable_systemd_service name
  machine.start_systemd_service name
end
