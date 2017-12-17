description "collects a list of scanned machines and adds them to the database if necessary"

contribute to: "scan" do
  scanned = @op.collect_contributions("scan_machines")
  @op.machines_found(scanned)
end
