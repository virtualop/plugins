description "waits until a SSH connection can be established (trying repeatedly)"

param! :machine

param "timeout", description: "number of seconds to wait for the condition to be met", default: 120
param "interval", description: "seconds to wait between tries", default: 5


run do |machine, timeout, interval|
  @op.wait("timeout" => timeout, "interval" => interval) do
    result = false

    begin
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
