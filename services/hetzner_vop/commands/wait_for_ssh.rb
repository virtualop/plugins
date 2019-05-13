description "waits until a SSH connection can be established (trying repeatedly)"

param! :machine

param "timeout", description: "number of seconds to wait for the condition to be met", default: 120
param "interval", description: "seconds to wait between tries", default: 5
param "expect_new_key", default: false,
  description: "set to true if a new host key should be expected, e.g. when the machine will have been reinstalled"


run do |machine, timeout, interval, expect_new_key|
  @op.wait("timeout" => timeout, "interval" => interval) do
    result = false

    begin
      if expect_new_key
        ip = if machine.metadata["type"] == "vm"
          machine.internal_ip
        else
          # get the external IP from the host's metadata (could be that we can not connect)
          machine.metadata["server_ip"]
        end
        @op.clean_known_host(ip: ip)
      end

      result = machine.test_ssh!
      if result
        $logger.info "SSH connection established."
      end
    rescue => e
      $logger.info "could not connect through SSH : #{e.message}"
    end

    result
  end
end
