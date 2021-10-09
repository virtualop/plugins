param! :machine
param! "service"
param  "key", "name to distinguish multiple passwords per service", default: nil

run do |params|
  path = path_from_params(params)
  Vault.logical.delete("vop/#{path}")
end
