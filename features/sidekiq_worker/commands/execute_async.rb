param! "the_request", default_param: true
param "vop_config", default: {}

run do |the_request, vop_config|
  the_request.origin ||= @options[:origin]
  AsyncExecutorWorker.perform_async(the_request.to_json, vop_config.to_json)
end
