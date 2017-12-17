param! :machine
param! "git_url", description: "URL to the github repository to deploy"
param! "domain", multi: true, description: "the domain on which the project should be deployed"
param "subfolder", description: "folder inside git checkout that should be published (as web root)"

contribute to: "deploy" do |machine, git_url, domain, params, subfolder|
  installation = Installation.find_or_create_by(host_name: machine.parent.name, vm_name: machine.name.split(".").first)
  installation.status = :deploying
  installation.save!

  machine.install_service("service" => "apache.apache")

  web_root = machine.git_clone_web(git_url)
  if subfolder
    web_root = File.join(web_root, subfolder)
  end
  machine.add_static_vhost("server_name" => domain, "web_root" => web_root)

  machine.parent.reverse_proxy.add_reverse_proxy(
    "server_name" => domain,
    "target_url" => "http://#{machine.internal_ip}/"
  )

  installation.status = :deployed
  installation.save!
end
