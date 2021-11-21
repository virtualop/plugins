# kudos https://tomlankhorst.nl/import-remote-mysql-db-over-ssh/

param! :machine
param! "source_machine", lookup: lambda { @op.machines.map(&:name) }
param  "source_user"
param! "database", lookup: lambda { |params| @op.user_databases(machine: params["source_machine"]).map(&:name) }
param  "target_database"

run do |params, machine, source_machine, database|
  source_user, target_database = params["source_user"], params["target_database"]
  target_database ||= database
  $logger.info "copying database #{database} from #{source_machine} #{target_database == database ? "to #{machine.name}" : "into #{target_database} on #{machine.name}"}"

  machine.create_database target_database

  connection_string = [
    (source_user unless source_user.nil?),
    source_machine
  ].compact.join("@")
  ssh_command = "ssh -C #{connection_string} 'sudo mysqldump #{database}' | sudo mysql #{target_database}"
  machine.ssh ssh_command
end
