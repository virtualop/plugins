param! :machine

# TODO locking might be a good idea

run do |plugin, machine|
  # prepare generator_path
  generator_path = plugin.config["generator_path"]
  unless generator_path.end_with? "/"
    generator_path += "/"
  end
  machine.mkdirs(generator_path)

  # data for the template
  data = {
    machine: machine,
    includes: {}
  }

  # figure out IP and netmask
  internal_ip = machine.internal_ip
  if internal_ip.nil?
    raise "no internal IP found for #{machine.name}"
  end

  netmask_ip = machine.internal_ip.split("\.")[0..2].push("0").join(".")
  # TODO allow other netmasks
  data[:netmask] = "#{netmask_ip}/24"
  data[:has_proxy?] = ! machine.reverse_proxy.nil?
  if data[:has_proxy?]
    # read the proxy's IP without connecting to it
    addresses = machine.list_vms_with_addresses
    data[:proxy_ip] = addresses.select { |x| x["name"] == "proxy" }.first["address"]
  end

  # prepare includes
  drop_dir = plugin.config["include_path"]
  if machine.file_exists(drop_dir)
    %w|prerouting input forward output|.each do |phase|
      phase_dir = drop_dir + '/' + phase
      if machine.file_exists(phase_dir)
        data[:includes][phase.to_sym] = "# #{phase} rules included from #{phase_dir}\n"
        machine.list_files(phase_dir).each do |file|
          full_name = "#{phase_dir}/#{file["name"]}"
          data[:includes][phase.to_sym] += machine.read_file(full_name) + "\n"
        end
      end
    end
  end

  # generate from template
  script_path = generator_path + plugin.config["script_name"]
  machine.write_template(
    template: plugin.template_path("iptables_minimal.sh.erb"),
    to: script_path,
    bind: OpenStruct.new(data).instance_eval { binding }
  )

  machine.ssh("chmod +x #{script_path}")

  machine.list_files! generator_path

  script_path
end
