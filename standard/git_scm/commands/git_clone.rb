description 'clones a git repository into a new directory'

param :machine

param! "git_url", "the git URL to use", :default_param => true
param :git_branch
param "git_tag", "the name of a tag that should be checked out"
param "directory", "the target directory to checkout into (defaults to $HOME/project_name)"
param "force", "set (to any value) if you want to override existing target directories"

on_machine do |machine, params|
  dir = params["directory"] || machine.home + '/' + params["git_url"].split("/").last.split(".").first
  
  file_exists = machine.file_exists("file_name" => dir)
  
  if file_exists and not params.has_key?('force')
    raise "the target directory #{dir} exists already, refusing cowardly to continue"
  end
    
  if file_exists and params.has_key?('force')
    # from the dont-do-this-at-home department
    machine.rm("recursively" => "true", "file_name" => dir)      
  end
  command = "git clone "
  if params.has_key?('git_branch') and params["git_branch"] != ''
    command += " -b #{params["git_branch"]}"
  end 
  command += " #{params["git_url"]}"
  directory = params["directory"]
  command += " #{directory}" if directory
  begin
    machine.ssh command    
  rescue => detail
    # TODO this kind of logic should probably be somewhere higher in the chain
    if /could not create.+Permission denied/ =~ detail.message
      user_name = machine.id['user']
      machine.as_user('root') do |root|
        root.mkdir directory
        root.chown('file_name' => directory, 'ownership' => "#{user_name}")        
      end
      machine.ssh command
    else
      raise
    end
  end
  
  if params.has_key?('git_tag') and params["git_tag"] != ''    
    machine.ssh "cd #{dir} && git checkout #{params["git_tag"]}"
  end
  
  @op.without_cache do
    machine.file_exists("file_name" => dir)
    machine.list_working_copies
    machine.list_working_copies_with_projects
  end
end