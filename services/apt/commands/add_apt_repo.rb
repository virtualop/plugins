param! :machine
param! "url"
param! "dist", default: "stable"
param! "alias"
param! "key"
param "component", default: ""
param "arch", default: nil

run do |params, machine, component|
  # TODO verify that repo[:alias] is a valid filename?

  arch = params["arch"] ? "[arch=#{params["arch"]}]" : ""
  source_line = "deb #{arch} #{params["url"]} #{params["dist"]} #{component}"

  machine.ssh("request_pty" => true,
    "command" => "echo '#{source_line}' | sudo tee /etc/apt/sources.list.d/#{params["alias"]}.list")
  machine.ssh("request_pty" => true, "command" => "wget -qO - #{params["key"]} | sudo apt-key add")
  machine.sudo("apt-get update")
end
