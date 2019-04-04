param! :machine
param! :known_service, default_param: true

allows_extra

run do |params|
  request = ::Vop::Request.new(@op, "install_service", params)
  @op.execute_async(request)
end
