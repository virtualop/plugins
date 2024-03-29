on :machine

entity do |machine|
  ip = machine.internal_ip

  result = {}

  # get all vhosts configured on the reverse proxy
  parent = machine.parent
  if parent
    vhosts = machine.parent.reverse_proxy.vhosts

    # select the ones pointing to this machine
    vhosts.each do |v|
      next if v["proxy"].nil? || v["proxy"]["host"].nil?

      if v["proxy"]["host"] == ip
        result[v["domain"]] ||= {}
        if v["https"]
          result[v["domain"]]["https"] = true
        end
      end
    end
  end

  # reformat into array of hashes
  result = result.map do |k,v|
    v["name"] = k
    v
  end

  # # and post-process
  result.map do |domain|
    protocol = domain["https"] ? "https" : "http"
    domain["url"] = "#{protocol}://#{domain["name"]}"
    domain
  end
end
