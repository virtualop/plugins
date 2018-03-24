description "collects a list of scanned machines and adds them to the database if necessary"

contribute to: "scan" do
  scanned = @op.collect_contributions("scan_machines")
  $logger.debug "scanned contributions: #{scanned.size}"
  stats = @op.machines_found(scanned)

  if inspect
    @op.machines.each do |machine|
      machine.inspect_async
      #InspectMachineWorker.perform_async(machine.name)
    end
  end

  stats
end
