description "creates a new directory on a machine that might be converted into a working copy later (now thats specific)"

param :machine
param! 'name'

param 'service_root'

param 'web_project', 'set to true to add the +static_html+ flag and a domain parameter'
param 'domain'

on_machine do |machine, params|
  name = params['name']
  
  # TODO duplicate in new_project
  service_root = 
    if params.has_key?("service_root") 
      params["service_root"]
    else
      if params['web_project']
        "/var/www/html/#{name}"
      else
        # ownCloud/projects?
        "#{machine.home}/#{name}"
      end
    end
  
  machine.mkdir service_root
  
  machine.initialize_vop_project({'directory' => service_root}.merge_from(params, :name, :web_project, :domain))
  
  @op.without_cache do
    machine.list_working_copies
  end
  
  #if params['domain']
  #  machine.install_service_from_working_copy('working_copy' => name, 'service' => name, 'extra_params' => { 'domain' => params['domain'] })    
  #end
  
  service_root
end

