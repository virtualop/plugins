description "called on a (libvirt) virtualization host, this will return the reverse proxy running on it (if any)"

param! :machine

run do |machine|
  result = nil
  if machine.detect_services.include?("libvirt.libvirt")
    if machine.list_vms.map { |x| x["name"] }.include? "proxy"
      result = @op.machines["proxy.#{machine.name}"]
    end
  end
  result
end
