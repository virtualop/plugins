description "collects a list of scanned machines and adds them to the database if necessary"

contribute to: "scan" do
  scanned = @op.collect_contributions("scan_machines")
  $logger.debug "scanned contributions: #{scanned.size}"

  stats = @op.machines_found(scanned)

  # TODO clean machines that have no longer been found and/or mark them

  # TODO reactivate @op.machines!.each &:inspect_async

  stats
end
