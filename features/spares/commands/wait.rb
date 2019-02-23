description "waits until a condition has been met"

block_param! "block", description: "the block that should be executed periodically. should return true if the condition is met, false otherwise"
param! "timeout", description: "number of seconds to wait for the condition to be met", default: 60
param! "interval", description: "seconds to wait between tries", default: 1
param  "error_text", description: "text that is displayed when the specified timeout is reached", default: "condition not met"

run do |timeout, interval, error_text, params, block|
  seconds_waited = 0

  current_result = false
  while (seconds_waited < timeout.to_i) do
    begin
      current_result = block.call()
      $logger.debug("checked condition : #{current_result}")
    rescue Exception => e
      $logger.warn("got an exception while waiting : #{e.message}")
    end

    break if current_result

    sleep(interval.to_i)
    seconds_waited += interval.to_i
  end

  raise Exception.new(error_text) unless current_result
  current_result
end
