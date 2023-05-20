param! :machine
param! "name"
param! "content"

run do |plugin, machine, name, content|
  machine.write_file(
    file_name: "/etc/systemd/system/#{name}.service",
    content: content,
    sudo: true
  )
  # TODO: machine.systemd_reload
  machine.sudo "systemctl daemon-reload"
  machine.list_systemd_services!
end
