process_regex /libvirtd/

# https://help.ubuntu.com/lts/serverguide/libvirt.html
deploy package: ["qemu-kvm", "libvirt-bin"]
deploy package: "virtinst"
deploy package: "libosinfo-bin"
