param! :machine
param! "ssh_key"

run do |machine, ssh_key|
  # enable re-install on next boot
  install_options = machine.enable_linux_install(ssh_key: ssh_key)
  $logger.info "linux installation activated:\n#{install_options.pretty_inspect}"

  machine.reboot_and_wait_for_ssh(
    "expect_new_key" => true,
    "timeout" => 30 * 60,
    "interval" => 15
  )

  machine.install_service "ubuntu.base"
  machine.install_service "ubuntu.host"
end
