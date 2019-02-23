param! :machine
param! "name"
param! "exec_start", "path to a script/executable to run"
param "description"
param "user", default: nil
param "after", multi: true, description: "list of systemd units the new config depends on"

run do |plugin, machine, name, exec_start, params|
  description, user, after = params["description"], params["user"], params["after"]
  machine.write_template(
    template: plugin.template_path("systemd_service"),
    to: "/etc/systemd/system/#{name}.service",
    bind: binding
  )
  machine.sudo "systemctl daemon-reload"

  machine.list_systemd_services!
end
