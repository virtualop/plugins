process_regex /libvirtd/

# https://ubuntu.com/server/docs/virtualization-libvirt
# + dnsmasq
# + qemu-utils (for qemu-img)
deploy package: ["libvirt-daemon-system", "qemu-kvm", "qemu-utils", "dnsmasq"]
deploy package: ["virtinst", "libosinfo-bin"]

param "adjust_network", default: false
param "subnet", default: "123"

deploy do |machine, params|
  subnet = params["subnet"]
  # the root user should belong to group libvirt
  root_in_group_libvirt = !! /libvirt/.match(machine.ssh("id"))
  unless root_in_group_libvirt
    machine.sudo "adduser root libvirt"
  end

  # the default network should have the correct IP
  puts "adjust network ? #{params["adjust_network"]}"
  machine.update_network_ip(
    "ip" => "192.168.#{subnet}.1",
    "dhcp_start" => "192.168.#{subnet}.2",
    "dhcp_stop" => "192.168.#{subnet}.254"
  ) if params["adjust_network"]

  # TODO : add domain

  # the default network should be running
  active_networks = machine.list_networks.select { |network|
    network["state"] == "active"
  }.map { |x| x["name"] }
  unless active_networks.include? "default"
    machine.sudo "virsh net-start default"
  end
  machine.sudo "virsh net-autostart default"
end
