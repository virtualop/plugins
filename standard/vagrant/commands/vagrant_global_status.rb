param! 'machine'

run do |machine|
  machine.ssh "vagrant global-status --prune"
  output = machine.ssh "vagrant global-status"

  result = []

  # id       name     provider   state    directory
  # --------------------------------------------------------------------------
  # 96c4f6f  bar      virtualbox poweroff /home/philipp/lab/vagrant/bar
  # 7b81b7a  foo      libvirt    shutoff  /home/philipp/lab/vagrant/foo
  output.lines[2..-1].each do |line|
    parts = line.strip.split
    break if parts.size < 5

    (vagrant_id, name, provider, state, directory) = parts

    # the vm name as produced by vagrant-libvirt seems to be the project directory name plus the name defined in the Vagrantfile
    full_name = directory.split('/')[-1] + '_' + name
    result << {
      id: vagrant_id,
      name: name,
      full_name: full_name,
      provider: provider,
      state: state,
      directory: directory
    }
  end

  result
end
