def param_service
  param! "service",
    default_param: true,
    lookup: lambda { |params|
      @op.list_systemd_services("machine" => params["machine"] ).map { |x| x["name"] }
    }
end
