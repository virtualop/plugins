# libvirt
deploy service: "libvirt.libvirt"
deploy do |machine|
    machine.list_vms!
end

# iptables
deploy do |machine|
    # TODO persist iptables
    iptables_script = machine.generate_iptables_script
    machine.ssh(iptables_script)
    iptables_script
end

# remix ubuntu iso
deploy service: "isoremix.isoremix"
deploy do |machine|
    machine.fetch_ubuntu_iso(version: "18.04")
    machine.rebuild_debian_iso(source_iso: "ubuntu-18.04.1-server-amd64.iso")
end
