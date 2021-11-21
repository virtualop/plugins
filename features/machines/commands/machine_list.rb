run do
  @op.machines.sort_by(&:name).map do |m|
    scan_from = m.scan_result["scan_from"]
    if scan_from
      m.data["last_seen"] = Time.at(scan_from)
    end
    m.data["ssh_status"] = m.scan_result["ssh_status"]
    m
  end
end
