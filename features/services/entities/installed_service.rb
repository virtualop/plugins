on :machine

entity do |plugin, machine|
  machine = @op.machines[machine]
  record_dir = plugin.config["installed_services_dir"]
  if machine.file_exists(record_dir)
    machine.list_files(record_dir).map do |file|
      content = machine.read_file("#{record_dir}/#{file["name"]}")
      JSON.parse(content)
    end
  end
end
