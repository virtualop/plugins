param! "path"
param! "data"

run do |path, data|  
  Vault.logical.write("vop/#{path}", **data)
end
