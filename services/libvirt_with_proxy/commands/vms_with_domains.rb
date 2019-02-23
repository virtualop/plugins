param! :machine

# TODO read_only

run do |machine|
  vms = machine.list_vms_with_addresses.map do |vm|
    [ vm["address"], vm ]
  end.to_h

  proxy = @op.machines["proxy.#{machine.name}"]
  proxy.vhosts.map do |vhost|
    if vhost["proxy"]
      ip = vhost["proxy"]["host"]
      if vms.has_key? ip
        vhost["proxy"]["hostname"] = vms[ip]["name"]
      end
    end
    vhost.data
  end
end
