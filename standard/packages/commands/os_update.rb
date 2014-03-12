param :machine

on_machine do |machine, params|
  case machine.distro
  when "centos"
    machine.yum_update(params)
  when "ubuntu"
    machine.apt_os_update    
  else
    raise "os_update not yet implemented for #{machine.distro}, sorry."
  end
end
