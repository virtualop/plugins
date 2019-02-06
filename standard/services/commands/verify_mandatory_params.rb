param! :machine
param! :service, default_param: true

allows_extra

run do |plugin, machine, service, params|
  svc_params = service.data["params"]
  #$logger.debug "verify mandatory params, svc_params : #{svc_params.pretty_inspect()}"
  svc_params.each do |svc_param|
    if svc_param.has_key?("options") && svc_param["options"]["mandatory"]
      unless params.has_key?(svc_param.name)
        raise "missing param '#{svc_param.name}'"
      end
    end
  end

  true
end
