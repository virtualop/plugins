param! "host_name"
param! "vm_name"

run do |plugin, host_name, vm_name|
  redis = plugin.state[:redis]

  full_name = "#{vm_name}.#{host_name}"
  cache_key = "vop.installation_status.#{full_name}"
  redis.get(cache_key)
end
