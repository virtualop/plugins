description "writes skeleton versions of all necessary vop metadata into a project directory"

param :machine
param! "directory", "path to the directory to write into"
param! "name", "vop project name"

param 'web_project', 'set to true to add the +static_html+ flag and a domain parameter'
param 'domain'

param 'extra_install_command_header'

on_machine do |machine, params|
  dotvop_dir = "#{params["directory"]}/.vop"
  machine.mkdir("dir_name" => dotvop_dir)
  
  machine.initialize_plugin("directory" => dotvop_dir, "name" => params["name"])
  
  params['directory'] = dotvop_dir
  
  if params['web_project']
    params['extra_install_command_header'] = 'param "domain"'
    params['extra_content'] = 'static_html'
  end
  
  descriptor = @op.add_service(params)
  
  machine.chmod('file_name' => dotvop_dir, 'permissions' => 'go+rx')
  
  if params['web_project'] && params['domain']
    machine.install_service_from_directory(
      'directory' => params['directory'],
      'service' => params['name'],
      'extra_params' => {
        'domain' => params['domain']   
      } 
    )
  end
  
  working_copy = machine.list_working_copies.select { |x| x['path'] == params['directory'] }.first
  if working_copy
    @op.without_cache do
      machine.working_copy_details('working_copy' => working_copy['name'])
    end
  end
  
  descriptor
end
