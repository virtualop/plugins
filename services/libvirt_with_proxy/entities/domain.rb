on :machine

entity do |machine|
  machine = @op.machines[machine]
  ip = machine.internal_ip

  # get all vhosts configured on the reverse proxy
  vhosts = machine.parent.reverse_proxy.vhosts

  # select the ones pointing to this machine
  result = {}
  vhosts.each do |v|
    next if v["proxy"].nil? || v["proxy"]["host"].nil?

    if v["proxy"]["host"] == ip
      result[v["domain"]] ||= {}
      if v["https"]
        result[v["domain"]]["https"] = true
      end
    end
  end

  result.map do |k,v|
    v["name"] = k
    v
  end
end
