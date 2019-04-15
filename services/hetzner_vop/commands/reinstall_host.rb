param! :machine
param! "ssh_key"

run do |machine, ssh_key|
  # get the external IP from the host's metadata (could be that we can not connect)
  external_ip = machine.metadata["server_ip"]
  $logger.info "about to reinstall #{machine.name} (#{external_ip})"

  # enable re-install on next boot
  install_options = machine.enable_linux_install(ssh_key: ssh_key)

  $logger.info "linux installation activated:\n#{install_options.pretty_inspect}"

  # try to trigger a reboot through SSH, handle expected error
  begin
    machine.ssh "shutdown -r now"
    $logger.info "triggered reboot"
  rescue
    $logger.info "caught exception during host restart, probably normal"
  end

  $logger.info "reboot triggered, waiting before testing SSH..."
  sleep 60 * 2
  @op.wait(timeout: 30 * 60, interval: 15) do
    # the known host key in SSH is outdated
    @op.clean_known_host(ip: external_ip)
    machine.test_ssh!
  end

  $logger.info "SSH connect successful"
  $logger.info "hostname : #{machine.hostname}"
  $logger.info "uptime : #{machine.ssh("uptime")}"

  # to avoid package lock issues during apt update in ubuntu.base_install
  sleep 15

  machine.install_service "ubuntu.base"
  machine.install_service "ubuntu.host"
end
