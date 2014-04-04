description "installs services onto a machine"

param :machine

param 'service', 'a service that should be installed (url-encoded)',
  :allows_multiple_values => true,
  :default_value => [],
  :default_param => true  
  
on_machine do |machine, params|
  params['service'].each do |svc_url|
    svc_hash = CGI.parse(svc_url)
    
    type = svc_hash.delete('type').first
    name = svc_hash.delete('name').first
    
    case type
    when 'canned'
      machine.install_canned_service(
        'service' => name,
        'extra_params' => svc_hash
      )
    when 'github'
      machine.install_service_from_github(
        'github_project' => name,
        'extra_params' => svc_hash                        
      )
    else
      $logger.warn "unknown service type '#{type}' - ignoring"
    end 
  end
end
