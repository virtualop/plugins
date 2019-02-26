process_regex /libvirtd/

# https://help.ubuntu.com/lts/serverguide/libvirt.html
deploy package: ["qemu-kvm", "libvirt-bin"]
deploy package: "virtinst"
deploy package: "libosinfo-bin"

param "subnet", default: "123"

deploy do |machine, params|
  subnet = params["subnet"]
  # the root user should belong to group libvirt
  root_in_group_libvirt = !! /libvirt/.match(machine.ssh("id"))
  unless root_in_group_libvirt
    machine.sudo "adduser root libvirt"
  end

  # the default network should have the correct IP
  machine.update_network_ip(
    "ip" => "192.168.#{subnet}.1",
    "dhcp_start" => "192.168.#{subnet}.2",
    "dhcp_stop" => "192.168.#{subnet}.254"
  )

  # the default network should be running
  active_networks = machine.list_networks.select { |network|
    network["state"] == "active"
  }.map { |x| x["name"] }
  unless active_networks.include? "default"
    machine.sudo "virsh net-start default"
  end
  machine.sudo "virsh net-autostart default"
end
