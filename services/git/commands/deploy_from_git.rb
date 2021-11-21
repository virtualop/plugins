param! :machine
param! "git_url", description: "URL to the github repository to deploy"
param "domain", multi: true, description: "the domain on which the project should be deployed"
param "subfolder", description: "folder inside git checkout that should be published (as web root)"
param "dir"

contribute to: "deploy" do |machine, git_url, params, subfolder|
  machine.track_machine_installation_status(
    status: "deploying"
  )

  domain = params["domain"]
  if domain
    machine.install_service("known_service" => "apache.apache")

    web_root = machine.git_clone_web(git_url)
    if subfolder
      web_root = File.join(web_root, subfolder)
    end

    machine.add_static_vhost("server_name" => domain, "web_root" => web_root)
    machine.publish(domain)
  else
    machine.git_clone("url" => git_url, "dir" => params["dir"])
  end

  machine.track_machine_installation_status(
    status: "deployed"
  )
end
