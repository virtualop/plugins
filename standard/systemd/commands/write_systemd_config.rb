param! :machine
param! "name"
param! "exec_start", "path to a script/executable to run"
param "description"
param "user"

run do |plugin, machine, name, exec_start, params|
  description, user = params["description"], params["user"]
  machine.write_template(
    template: plugin.template_path("systemd_service"),
    to: "/etc/systemd/system/#{name}.service",
    bind: binding
  )
  machine.sudo "systemctl daemon-reload"

  machine.list_systemd_services!
end
