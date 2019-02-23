param! :machine

param! "name"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25

param! "iso_regex", "a regular expression to filter ISO names against"

run do |machine, params|
  iso_name = machine.find_latest(iso_regex: params.delete("iso_regex"))
  $logger.info "latest ISO found : #{iso_name}"

  @op.new_vm_from_iso(params.merge({"iso" => iso_name}))
end
