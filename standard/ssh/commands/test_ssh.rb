require "timeout"

param! "machine"
param "seconds", :default => 10

read_only

KNOWN_MESSAGES = ["execution expired", "No route to host", "Connection refused", "closed stream", "getaddrinfo: Name or service not known", "Broken pipe"]
run do |params, seconds|
  result = nil

  seconds = seconds.to_i
  begin
    Timeout::timeout(seconds) do
      @op.ssh("machine" => params["machine"], "command" => "id")
      result = true
    end
  rescue => detail
    matched = nil
    KNOWN_MESSAGES.each do |text|
      pattern = Regexp.new(text)
      if detail.message =~ pattern
        $logger.debug "known error #{pattern}"
        result = false
        matched = true
        break
      end
    end
    unless matched
      $logger.warn "unknown error : #{detail.message}"
      raise detail
    end
  end

  result
end
