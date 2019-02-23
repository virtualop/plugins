param! :machine
param! "url"
param! "dist", default: "stable"
param! "alias"
param! "key"
param "component", default: ""

run do |params, machine, component|
  # TODO verify that repo[:alias] is a valid filename?
  machine.ssh("request_pty" => true,
    "command" => "echo 'deb #{params["url"]} #{params["dist"]} #{component}' | sudo tee /etc/apt/sources.list.d/#{params["alias"]}.list")
  machine.ssh("request_pty" => true, "command" => "wget -qO - #{params["key"]} | sudo apt-key add")
  machine.sudo("apt-get update")
end
