param! :machine
param! "github_project", description: "full name (author/repo) of the project that should be checked out"
param "domain", multi: true, description: "the domain on which the project should be deployed"
param "subfolder", description: "folder inside git checkout that should be published (as web root)"

contribute to: "deploy" do |params, github_project|
  params.delete("github_project")

  @op.deploy_from_git(
    params.merge("git_url" => "https://github.com/#{github_project}.git")
  )
end
