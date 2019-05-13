param! :machine
param "expect_new_key", default: false,
  description: "set to true if a new host key should be expected, e.g. when the machine will have been reinstalled"

param "timeout", description: "number of seconds to wait for the condition to be met", default: 120
param "interval", description: "seconds to wait between tries", default: 5

run do |params, machine, expect_new_key, timeout, interval|
  begin
    machine.sudo "reboot"
  rescue
    $logger.debug "caught exception during reboot, probably normal"
  end

  # TODO @op.ping_until_timeout(ip)
  # $logger.info "ping to #{ip} timed out, assuming reboot"
  $logger.info "reboot triggered, waiting 15 seconds before testing SSH..."
  sleep 15

  machine.wait_for_ssh(
    "timeout" => timeout,
    "interval" => interval,
    "expect_new_key" => expect_new_key
  )
  machine.ssh "uptime"
end
