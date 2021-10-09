def path_from_params(params)
  parts = [
    "service_password",
    params["machine"],
    params["service"]
  ]
  parts << params["key"] unless params["key"].nil?
  parts.join("/")
end
