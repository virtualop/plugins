class AsyncExecutorWorker
  include Sidekiq::Worker

  def perform(request_json, vop_config = {})
    begin
      op = ::Vop.boot

      # for the tests, we need to load extra plugins that are configured with auto_load=false
      # not sure how to generalize this, in production use cases this should probably be config
      config = JSON.parse(vop_config)
      config["optional_plugins"].each do |plugin|
        op.plugin(plugin).init
      end if config["optional_plugins"]

      request = ::Vop::Request::from_json(op, request_json)
      puts "performing #{request.command_name} #{request.param_values.pretty_inspect}"
      response = op.execute_request(request)
      puts "response : #{response.status}"
      puts response.result
    rescue => e
      puts "[ERROR] #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end
end
