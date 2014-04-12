description "adds vop configuration for a service inside a project, returns the descriptor filename"

param :machine
param! "directory", "path to the project"
param! "name", "name for the service"

param 'extra_content'
param 'extra_install_command_header'

on_machine do |machine, params|
  service_name = params["name"]
  
  dotvop_dir = params["directory"]
  service_dir = dotvop_dir + '/services'
  
  machine.mkdir("dir_name" => service_dir)
  
  descriptor = "#{service_dir}/#{service_name}.rb"
  descriptor_content = "# service #{service_name}"
  if params['extra_content']
    descriptor_content += "\n" + params['extra_content']
  end
  machine.write_file(
    'target_filename' => descriptor, 
    'content' => descriptor_content
  )
  
  install_command_file = [ dotvop_dir, '/commands/', "#{service_name}_install.rb" ].join("/")
  process_local_template(:install_command, machine, install_command_file, binding())
  
  descriptor
end
