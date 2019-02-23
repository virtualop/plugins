param! :machine

param! "name"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25

run do |machine, name, params|
  new_machine = @op.new_vm_from_latest(params.merge({"iso_regex" => "ubuntu"}))

  @op.track_installation_status(
    host_name: machine.name,
    vm_name: name,
    status: "base_installing"
  )

  new_machine.install_service("service" => "ubuntu.base_install")
end
