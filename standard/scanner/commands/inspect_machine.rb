param! :machine

run do |machine|
  result = {
    "ssh_status" => "unknown",
    "internal_ip" => "unknown"
  }

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

  if result["ssh_status"]
    begin
      result["internal_ip"] = machine.internal_ip
    rescue => e
      $logger.error "problem reading internal IP from #{machine.name} : #{e.message}"
    end

    result["distro"] = machine.distro
    result["processes"] = machine.processes!
    result["processes_top_mem"] = machine.processes_top_mem

    result["services"] = machine.detect_services!
  end
  result
end
