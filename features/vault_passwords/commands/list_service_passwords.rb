param! :machine
param! "service"

run do |params|
  path = path_from_params(params)
  Vault.logical.list("vop/#{path}")
end
