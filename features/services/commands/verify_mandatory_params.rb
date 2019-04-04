param! :machine
param! :known_service, default_param: true

allows_extra

run do |plugin, machine, known_service, params|
  detail = known_service.describe_service
  detail["params"].each do |svc_param|
    if svc_param.has_key?("options") && svc_param["options"]["mandatory"]
      unless params.has_key?(svc_param["name"])
        raise "missing param '#{svc_param["name"]}'"
      end
    end
  end

  true
end
