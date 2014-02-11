description "installs a vop service from a directory"

param :machine
param! "directory", "the service root from which to install (typically contains a .vop subdirectory)"
param! "service", "the name of the service contained inside the working copy that should be installed."

accept_extra_params
  
on_machine do |machine, params|
  vop_dir = "#{params["directory"]}/.vop"
  if machine.file_exists("file_name" => vop_dir)
    params.merge!({
      "descriptor" => vop_dir + "/services/#{params["service"]}.rb", 
      "descriptor_machine" => machine.name,
      "service_root" => params["directory"]
    })
    
    if params.has_key?('extra_params')
      params.merge! params['extra_params']
    end
    
    machine.install_service_from_descriptor(params)
  end
end