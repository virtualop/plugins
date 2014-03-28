param :machine

on_machine do |vm, params|
  target_file_name = '/etc/yum.repos.d/CentOS-Base.repo'
  
  vm.rm("file_name" => target_file_name) if vm.file_exists("file_name" => target_file_name)
  
  full_url = @op.plugin_by_name("installation").config_string("install_kernel_location")
  
  # we need to extract the mirror base from the URL that ends in
  #   $releasever/os/$basearch/
  mirror_base = full_url.split('/')[0..-3]
    
  process_local_template(:centos_base_repo, vm, target_file_name, binding())
end