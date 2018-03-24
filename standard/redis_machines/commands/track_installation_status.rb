param! "host_name"
param! "vm_name"
param! "status"

#block_param!

run do |host_name, vm_name, status, plugin|
  redis = plugin.state[:redis]

  full_name = "#{vm_name}.#{host_name}"
  cache_key = "vop.installation_status.#{full_name}"
  redis.set(cache_key, status)
end
