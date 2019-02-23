param! :machine
param "with_addresses", default: false

read_only

run do |machine, with_addresses|
  ext_result = machine.ssh_call("command" => "which virsh")
  if ext_result["result_code"].to_i > 0
    $logger.warn "no 'virsh' found on #{machine.name}"
    []
  else
    # TODO should we source /etc/profile generally before all ssh commands?
    output = machine.ssh ". /etc/profile && virsh list --all"

    data = output.strip.lines[2,output.length-1]
    data.map do |line|
      (unused_id, name, *state) = line.strip.split
      h = {
        "name" => name,
        "state" => state.join(" ")
      }
      if with_addresses
        h["ip"] = machine.vm_address(name)
      end
      h
    end
  end
end
