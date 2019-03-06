# libvirt
deploy service: "libvirt.libvirt"
deploy do |machine|
    machine.list_vms!
end

# iptables
deploy do |machine|
  machine.generate_and_run_iptables
  machine.persist_iptables
end


# remix ubuntu iso
deploy service: "isoremix.isoremix"
deploy do |machine|
    machine.fetch_ubuntu_iso(version: "18.04")
    machine.rebuild_debian_iso(source_iso: "ubuntu-18.04.2-server-amd64.iso")
end
