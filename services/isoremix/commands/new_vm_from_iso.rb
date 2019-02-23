param! :machine

param! "name"

param "memory", description: "in MB", default: 512
param "cpu_count", default: 1
param "disk_size", description: "in GB", default: 25

param! "iso", :lookup => lambda { |params| @op.list_rebuilt_isos("machine" => params["machine"]).map { |x| x["name"] } }

run do |params|
  base_path = isoremix_dir("rebuilt")
  iso = params.delete("iso")
  iso_path = File.join(base_path, iso)

  @op.new_vm(params.merge({"iso_path" => iso_path}))
end
