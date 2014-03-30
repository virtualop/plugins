description "installs a new machine and deploys services"

param! "vm_name", "the name for the machine to be created"

param 'machine', 'a host machine on which the virtual machine should be setup', :mandatory => false
param :environment

param "memory_size", "the amount of memory (in MB) that should be allocated for the new VM", :default_value => 512
param "disk_size", "disk size in GB for the new VM", :default_value => 25
param "vcpu_count", "the number of virtual CPUs to allocate", :default_value => 1

# TODO these should be merged into a 'services' parameter (multi)
param :github_project
param :git_branch
param :git_tag
param "canned_service", "name of a canned service to install on the machine", :allows_multiple_values => true

param "template", "name of a predefined set of location and kickstart URLs. see list_vm_templates", 
  :lookup_method => lambda { @op.list_vm_templates.pick(:name) },
  :default_value => 'centos'

accept_extra_params

notifications

execute do |params|
  params['machine'] ||= @op.installation_target
  
  @op.setup_vm(params)
end  