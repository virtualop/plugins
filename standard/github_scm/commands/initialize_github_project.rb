description "initializes an empty github repo so that working copies can be cloned from it"

param :machine
param "directory", "the directory in which the working copy should be initialized"

github_params
param :github_repo
  
on_machine do |machine, params|
  repo = @op.repos.select { |x| x['full_name'] == params['github_repo'] }.first
  pp repo
  
  # TODO check first if the user has write permissions to this repo       
  
  project_name = params["github_repo"].split("/").last
  dir_name = params.has_key?("directory") ? params["directory"] : project_name
  machine.mkdir("dir_name" => dir_name)
  [
    "git init",
    "touch README.md && git add README.md",
    "git commit -m 'first commit'"
  ].each do |x|
    machine.ssh("command" => "cd #{dir_name} && #{x}")
  end
  
  
  machine.ssh "cd #{dir_name} && git push -u origin master"
end  


