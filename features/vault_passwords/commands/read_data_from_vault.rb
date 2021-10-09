param! "path"

run do |path|
  Vault.logical.read("vop/#{path}").data
end
