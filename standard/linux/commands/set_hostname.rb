param! :machine
param! "new_name", default_param: true
param "new_domain", default: "local"

run do |machine, new_name, new_domain|
  full_name = "#{new_name}.#{new_domain}"

  current = machine.hostname
  if current == full_name
    $logger.info "hostname already #{current}, skipping"
  else
    machine.sudo "hostname #{full_name}"

    # TODO this might be setup-specific, extract?
    meta = machine.metadata
    new_entry = "#{full_name} #{new_name}"
    if meta["type"] == "host"
      machine.update_hosts_file(
        ip: machine.external_ip,
        content: new_entry
      )
    elsif meta["type"] == "vm"
      machine.update_hosts_file(
        ip: "127.0.1.1",
        content: new_entry
      )
    end

    # update /etc/hostname
    machine.write_file(
      "file_name" => "/etc/hostname",
      "content" => new_name,
      "sudo" => true
    )
  end
end
