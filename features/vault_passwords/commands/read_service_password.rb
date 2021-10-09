param! :machine
param! "service"
param  "key", "name to distinguish multiple passwords per service", default: nil

run do |params, machine, service, key|
  path = path_from_params(params)
  Vault.logical.read("vop/#{path}").data[:password]
end
