param! "path"

run do |path|
  Vault.logical.list("vop/#{path}")
end
