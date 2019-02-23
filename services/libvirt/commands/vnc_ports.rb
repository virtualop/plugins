param! :machine

show columns: %w|vm vnc vnc_port command|

invalidate do |machine|
  machine.processes!
end

run do |machine, params|
  machine.processes.map do |process|
    command = process["command"]
    h = {
      "command" => command[0..99]
    }
    if /virt-install/ =~ command
      if /--name\s+(\S+)/ =~ command
        h["vm"] = $1
      end
    elsif /qemu-system/ =~ command
      if /guest=([^,]+)/ =~ command
        h["vm"] = $1
      end
    end
    if h["vm"]
      if /vnc(?:,listen=|\s+)?([\d\.]+)(?:\:(\d+))?/ =~ process["command"]
        h["vnc"] = $1
        h["vnc_port"] = $2
      end
    end
    h.has_key?("vm") ? h : nil
  end.compact
end
