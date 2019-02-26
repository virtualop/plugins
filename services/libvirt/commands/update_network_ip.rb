description "updates IP address (and optionally netmask and dhcp range coordinates) for a network configuration"

param! :machine
param "network", default: "default"

param! "ip"
param "netmask"
param "dhcp_start"
param "dhcp_stop"

run do |machine, network, ip, params|
  # read current config
  dumped = machine.sudo("virsh net-dumpxml #{network}")
  parsed = XmlSimple.xml_in(dumped)
  parsed_ip = parsed["ip"].first
  current_address = parsed_ip["address"]

  if current_address.nil?
    $logger.error "no IP address found in output of 'virsh net-dumpxml', can not update."
  else
    $logger.info "found current IP : #{current_address}, changing to #{ip} ..."

    # change IP
    parsed_ip["address"] = ip

    # netmask
    if params.has_key? "netmask"
      parsed_ip["netmask"] = params["netmask"]
    end

    # DHCP range
    if params.has_key? "dhcp_start"
      dhcp = parsed_ip["dhcp"].first["range"].first
      dhcp["start"] = params["dhcp_start"]
      dhcp["end"] = params["dhcp_stop"]
    end
  end

  # write the result to a temp file
  remote_tmp = "/tmp/vop_libvirt_network_config_#{network}_#{Time.now.utc.to_i}.xml"
  $logger.debug "writing new XML to #{remote_tmp}"
  new_xml = XmlSimple.xml_out(parsed, {"rootname" => "network"})
  machine.write_file(file_name: remote_tmp, content: new_xml)

  # let libvirt read the updated config
  machine.sudo "virsh net-define #{remote_tmp}"

  # restart the network for changes to take effect
  machine.sudo "virsh net-destroy #{network}"
  machine.sudo "virsh net-start #{network}"

  dumped = machine.sudo "virsh net-dumpxml #{network}"
  $logger.info "reloaded network : #{dumped}"

  dumped
end
