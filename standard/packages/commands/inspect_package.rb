param :machine
param! "name", "the package to inspect", :default_param => true
param "filter", "regex to apply on the result"

display_type :list

on_machine do |machine, params|
  result = case machine.linux_distribution.split("_").first
  when 'centos', 'sles'
    machine.ssh("rpm -ql #{params['name']}").split("\n")
  else
    raise "inspect_package does not support distribution #{distribution} yet - please complain somewhere."
  end 
  
  result.delete_if do |x|
    /#{params['filter']}/ !~ x
  end if params['filter']
  
  result
end
