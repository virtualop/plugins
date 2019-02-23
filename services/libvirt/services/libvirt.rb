process_regex /libvirtd/

# https://help.ubuntu.com/lts/serverguide/libvirt.html
deploy package: ["qemu-kvm", "libvirt-bin"]
deploy package: "virtinst"
deploy package: "libosinfo-bin"

deploy do |machine|
  root_in_group_libvirt = !! /libvirt/.match(machine.ssh("id"))
  unless root_in_group_libvirt
    machine.sudo "adduser root libvirt"
  end

  active_networks = machine.list_networks.select { |network| network["state"] == "active" }.map { |x| x["name"] }
  unless active_networks.include? "default"
    machine.sudo "virsh net-start default"
  end
  machine.sudo "virsh net-autostart default"
end
