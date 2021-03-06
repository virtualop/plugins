param! :machine

run do |plugin, machine|
  now = Time.now.utc.to_i
  result = {
    "ssh_status" => "unknown",
    "internal_ip" => "unknown",
    "scan_from" => now
  }

  begin
    Timeout::timeout(60) do
      machine_type = machine.metadata["type"]
      if machine_type == "vm"
        # make sure the internal IP we've got is up to date
        machine.parent.vm_addresses!(name: machine.name.split(".").first)
      end
      machine.ssh_options!

      begin
        result["ssh_status"] = machine.test_ssh!
      rescue => e
        $logger.info "error testing ssh connect to #{machine.name} : #{e.message}"
        if e.message =~ /no SSH options/
          ssh_error = "no_ssh_options"
        else
          ssh_error = e.message
        end
        result["ssh_error"] = ssh_error
      end

      now = Time.now.utc.to_i
      result["scan_from"] = now

      machine.update_metadata new_data: {
        "ssh_status" => result["ssh_status"],
        "ssh_status_from" => now
      }

      if result["ssh_status"]
        begin
          result["internal_ip"] = machine.internal_ip
        rescue => e
          $logger.error "problem reading internal IP from #{machine.name} : #{e.message}"
        end

        result["distro"] = machine.distro

        garbled = machine.processes!
        ungarbled = garbled.map do |row|
          h = { }
          row.each do |k,v|
            h[k] = v.force_encoding("UTF-8")
          end
          h
        end
        result["processes"] = ungarbled

        machine.processes_top_mem

        result["services"] = machine.detect_services!

        # TODO packages contain non-serializable characters (like processes above)
        # result["packages"] = machine.list_packages
        if result["services"].include? "apache.apache"
          machine.vhosts!
          result["domains"] = machine.domains!.map(&:data)
        end

        if result["services"].include? "mysql.mysql"
          result["databases"] = machine.databases
        end
      end
    end
  rescue => detail
    raise "timed out while inspecting #{machine.name} : #{detail.message}"
  end

  redis = plugin.state[:redis]
  cache_key = "vop.scan_result.#{machine.name}"
  redis.set(cache_key, result.to_json)

  json_result = result.to_json
  redis.publish("scan", {
    "machine" => machine.name,
    "content" => result
  }.to_json())

  result
end
