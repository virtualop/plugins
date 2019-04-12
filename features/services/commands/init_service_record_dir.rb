param! :machine

run do |plugin, machine|
  record_dir = plugin.config["installed_services_dir"]

  machine.sudo "mkdir -p #{record_dir}"
  machine.sudo "chown #{machine.current_user} #{record_dir}"
end
