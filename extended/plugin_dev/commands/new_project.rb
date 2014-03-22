description 'creates a new github project and initializes it on the users dev machine'

param! 'name'

param 'domain'

param 'service_root'

param :machine, 'a dev machine to deploy onto', :mandatory => false

param :current_user

github_params

execute do |params|
  user = params['current_user']
  name = params['name']
    
  raise 'no user?' unless user
    
  # dev_machine = if params['machine']
    # params['machine']    
  # else
    # # try to find the user's dev machine
    # dev_name = "dev_#{user}"
    # # TODO needs rails_vop
    # user_machine = @op.list_rails_machines.select { |x| 
      # /^#{dev_name}/ =~ x['name'] 
    # }.first
#     
    # unless user_machine
      # raise "could not find dev machine for user #{user} - looked for #{dev_name}"  
    # end
    # $logger.info "auto-selecting #{user_machine['name']}"
    # user_machine['name']
  # end
  dev_machine = params['machine'] || @op.default_dev_machine
  
  @op.new_github_project('name' => name)
  full_name = @op.github_user['login'] + '/' + name
  
  is_web_project = params.has_key?('domain')
  
  @op.with_machine(dev_machine) do |machine|
    $logger.info "working on #{machine.name} as #{machine.id['user']}"
    
    service_root = 
      if params.has_key?("service_root") 
        params["service_root"]
      else
        if is_web_project
          "/var/www/html/#{name}"
        else
          "#{machine.home}/#{name}"
        end
      end
    
    machine.github_clone(
      'github_project' => full_name, 
      'directory' => service_root,
      'protocol' => 'ssh'
    )
    
    # TODO make sure that the current user can commit to this repo (we need authorized ssh keys)
    machine.initialize_github_project('directory' => service_root, 'github_repo' => full_name)
    descriptor = machine.initialize_vop_project('directory' => service_root, 'name' => name)
    
    install_params = {}
    
    if is_web_project
      machine.append_to_file('file_name' => descriptor, 'content' => 'static_html')
      install_params['domain'] = params['domain']
    end
    
    machine.install_service_from_directory(
      'directory' => service_root,
      'service' => name,
      'extra_params' => install_params 
    )
    
    machine.as_user('root') do |root|
      # TODO hardcoded marvin
      root.chown('file_name' => service_root, 'ownership' => 'marvin.apache')
    end
    
    if is_web_project
      index_html = "#{service_root}/index.html"
      process_local_template(:welcome, machine, index_html, binding())
      machine.allow_apache_read_access('file_name' => index_html)
    end
    
    machine.add_file_to_version_control('working_copy' => name, 'file_name' => 'index.html .vop')
    machine.commit_and_push_working_copy('working_copy' => name, 'comment' => 'generated index page, vop service descriptor')
  end   

end
