require "xmlsimple"

description "renames a VM (config file and storage pool)"

param! :machine
param! "vm_name"
param! "new_name", "the name for the new VM"

run do |machine, vm_name, new_name, params|
  # prepare new config
  xml_file_name = libvirt_config_file(vm_name)
  new_file_name = (xml_file_name.split("/")[0..-2] << "#{new_name}.xml").join("/")

  machine.sudo "cp #{xml_file_name} #{new_file_name}"
  machine.replace_in_file("file_name" => new_file_name, "source" => vm_name, "target" => new_name, "sudo" => true)

  # move volume
  pools = machine.list_pools.map { |x| x["name"] }
  pool = pools.include?("images") ? "images" : "default"

  old_volume_definition = machine.ssh "virsh vol-dumpxml --pool #{pool} #{vm_name}.img"
  old_volume = XmlSimple.xml_in(old_volume_definition)
  old_path = old_volume["target"].first["path"].first
  new_path = (old_path.split("/")[0..-2] << "#{new_name}.img").join("/")

  machine.ssh "mv #{old_path} #{new_path}"
  machine.ssh "touch #{old_path}"

  # swap
  machine.delete_vm("name" => vm_name)
  machine.sudo "virsh define #{new_file_name}"

  machine.list_vms!
end
