on :machine

entity do |plugin, machine|
  record_dir = plugin.config["installed_services_dir"]
  result = []
  if machine.file_exists(record_dir)
    machine.list_files(record_dir).each do |file|
      content = machine.read_file("#{record_dir}/#{file["name"]}")
      result << JSON.parse(content)
    end
  end
  result
end
