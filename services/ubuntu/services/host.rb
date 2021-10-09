# minimal requirements for a virtualization host:
#  * libvirt
#  * iptables
#  * ISO remixer to build custom install media for VMs
#  * reverse proxy to distribute incoming traffic

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
    machine.fetch_ubuntu_iso(version: "20.04")
    machine.rebuild_debian_iso(source_iso: "ubuntu-20.04.1-live-server-amd64.iso")
end

# prepare reverse proxy
deploy do |machine|
  machine.new_machine "proxy"
  machine.generate_and_run_iptables
end
