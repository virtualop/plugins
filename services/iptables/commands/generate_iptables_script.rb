param! :machine

run do |machine, plugin|
  generator_path = "/var/lib/virtualop/iptables.d"
  script_path = "#{generator_path}/minimal_fw.sh"

  machine.mkdirs(generator_path)

  internal_ip = machine.internal_ip
  if internal_ip.nil?
    raise "no internal IP found for #{machine.name}"
  end

  netmask_ip = machine.internal_ip.split("\.")[0..2].push("0").join(".")
  # TODO allow other netmasks
  internal_netmask = "#{netmask_ip}/24"
  has_proxy = ! machine.reverse_proxy.nil?

  data = {
    machine: machine,
    has_proxy?: has_proxy,
    netmask: internal_netmask
  }
  if has_proxy
    # read the proxy's IP without connecting to it
    addresses = machine.list_vms_with_addresses
    proxy_ip = addresses.select { |x| x["name"] == "proxy" }.first["address"]
    data["proxy_ip"] = proxy_ip
  end
  machine.write_template(
    template: plugin.template_path("iptables_minimal.sh.erb"),
    to: script_path,
    bind: OpenStruct.new(data).instance_eval { binding }
  )

  machine.ssh("chmod +x #{script_path}")

  script_path
end
