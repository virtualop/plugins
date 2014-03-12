param :machine

as_root do |machine, params|
  [ 'update', 'upgrade -y', 'dist-upgrade -y', 'check', 'autoclean -y', 'autoremove -y' ].each do |cmd|
    machine.ssh "apt-get #{cmd}"
  end
end

