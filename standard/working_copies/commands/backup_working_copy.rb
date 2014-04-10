description 'creates a tarball from a working copy'

param :machine
param :working_copy, '', :default_param => true

on_machine do |machine, params|
  detail = machine.working_copy_details(params)
  
  local_backup_dir = "#{machine.home}/tmp"
  tarball = "#{local_backup_dir}/#{detail['name']}.tgz"
  
  machine.tar(
    'tar_name' => tarball, 
    'files' => '.', 
    'working_dir' => detail['path']
  )
  
  tarball
end
