param! :machine
param! :service, default_param: true

allows_extra

run do |plugin, machine, service, params|
  svc_params = service.data["params"]
  svc_params.each do |svc_param|
    if svc_param.options[:mandatory]
      unless params.has_key?(svc_param.name)
        raise "missing param '#{svc_param.name}'"
      end
    end
  end

  true
end
