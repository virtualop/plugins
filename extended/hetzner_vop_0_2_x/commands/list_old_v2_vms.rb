param! :machine

run do |machine|
  dir_name = "/var/lib/virtualop/machines/"
  $logger.info "searching old vop 0.2.x style VMs on #{machine.id} in #{dir_name}"

  result = []

  if machine.test_ssh
    if machine.file_exists("path" => dir_name)
      $logger.info "dir #{dir_name} exists on #{machine.name} ? #{machine.file_exists(dir_name)}"

      files = machine.list_files("dir" => dir_name)
      files.each do |file|
        full_name = File.join(dir_name, file["name"])
        yaml = machine.read_file("file" => full_name)
        data = YAML.load(yaml)

        hash = {
          "type" => "vm",
          "name" => "#{data["vm_name"]}.#{machine.id}",
        }

        %w|memory_size vcpu_count disk_size bridge|.each do |key|
          hash[key] = data[key] unless data[key].nil?
        end

        if data["extra_arg"]
          data["extra_arg"].each do |line|
            (key, value) = line.split("=")
            hash[key] = value
          end
        end

        result << hash
      end
    else
      $logger.debug "dir #{dir_name} does not exist on #{machine.name}"
    end
  else
    $logger.warn "machine #{machine.id} not reachable by SSH"
  end

  result
end
