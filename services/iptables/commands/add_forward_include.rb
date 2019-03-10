description "adds a script that should be included into the forward section"

param :machine, "the machine on which the iptables script is generated"
param! "source_machine", "name of the machine for which this include has been generated", lookup: lambda { @op.machines(&:name) }
param! "service", "name of the service for which the include has been generated"
param! "content", "the script content"

run do |plugin, machine, source_machine, service, content|
  config_file = "#{source_machine}_#{service}.conf"
  drop_dir = "#{plugin.config["include_path"]}/forward"
  unless machine.file_exists(drop_dir)
    machine.mkdirs(drop_dir)
  end
  machine.write_file(
    file_name: "#{drop_dir}/#{config_file}",
    content: content
  )
end
