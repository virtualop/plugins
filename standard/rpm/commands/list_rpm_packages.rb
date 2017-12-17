description "returns a list of installed RPM packages"

param! :machine

read_only

show columns: [ :full_string, :name, :version ]

# TODO this used to be in 0.2:
# available_if do |params|
#   @op.with_machine(params["machine"]) do |machine|
#     machine.linux_distribution.split("_").first == "centos" or
#     machine.linux_distribution.split("_").first == "sles"
#   end
# end

contribute to: "list_packages" do |machine|
  #ivtv-firmware-20080701-20.2.noarch
  #e2fsprogs-1.41.12-3.el6.x86_64
  ssh_regex(machine, "rpm -qa", /^((.+?)-(\d+.+))$/, [:full_string, :name, :version])
end
