param! :machine
param! :known_service
param! "install_block"

allows_extra

run do |machine, known_service, install_block, params, plugin|
  $logger.debug "run install block for #{known_service.name}@#{machine.name}"
  svc = plugin.state[:services].select { |x| x.name == known_service["name"] }.first

  # add in default values for service params
  svc.params.each do |p|
    param_name = p.name
    unless params.has_key? param_name
      if p.options.has_key? :default
        params[param_name] = p.options[:default]
      end
    end
  end

  block_param_names = install_block.parameters.map { |x| x.last }
  payload = []
  block_param_names.each do |block_param_name|
    case block_param_name.to_s
    when "machine"
      payload << machine
    when "params"
      payload << params
    when "plugin"
      payload << svc.plugin
    else
      if params.has_key? name.to_s
        payload << params[name.to_s]
      elsif params.has_key? name
        payload << params[name]
      else
        raise "unknown block param #{block_param_name} in installation block for service #{known_service["name"]}"
      end
    end
  end

  install_block.call(*payload)
end
