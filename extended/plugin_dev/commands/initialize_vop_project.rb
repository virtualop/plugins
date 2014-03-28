description "writes skeleton versions of all necessary vop metadata into a directory"

param :machine
param! "directory", "path to the directory to write into"
param! "name", "vop project name"

param 'web_project', 'set to true to add the +static_html+ flag and a domain parameter'

param 'extra_install_command_header'

on_machine do |machine, params|
  dotvop_dir = "#{params["directory"]}/.vop"
  machine.mkdir("dir_name" => dotvop_dir)
  machine.initialize_plugin("directory" => dotvop_dir, "name" => params["name"])
  
  if params['web_project']
    params['extra_install_command_header'] = 'param "domain"'
    params['extra_content'] = 'static_html'
  end
  @op.add_service(params)
end
