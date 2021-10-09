param! :machine
param! "service"
param  "key", "name to distinguish multiple passwords per service", default: nil
param! "password"

run do |params, machine, service, password, key|
  path = path_from_params(params)
  @op.write_data_into_vault("path" => path, "data" => { password: password })
end
