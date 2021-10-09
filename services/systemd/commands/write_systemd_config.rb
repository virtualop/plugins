param! :machine
param! "name"
param! "exec_start", "path to a script/executable to run"
param "description"
param "user", default: nil
param "after", multi: true, description: "list of systemd units the new config depends on"

run do |plugin, machine, name, exec_start, params|
  description, user, after = params["description"], params["user"], params["after"]
  machine.write_systemd_config_file(content: plugin.template(:systemd_service))
  machine.sudo "systemctl daemon-reload"
  machine.list_systemd_services!
end
