description "generates a new key pair on the selected machine"
#
param :machine
param "ssh_dir", "the ssh configuration directory (defaults to $HOME/.ssh)"

run do |machine, params|
  ssh_dir = params.has_key?("ssh_dir") ? params["ssh_dir"] : ".ssh"
  private_keyfile = ssh_dir + "/id_rsa"

  unless machine.file_exists(private_keyfile)
    machine.mkdirs ssh_dir
    machine.ssh "ssh-keygen -N '' -f #{private_keyfile}"
    machine.ssh "cd #{ssh_dir} && cat id_rsa.pub >> authorized_keys"
  end

  #machine.file_exists! private_keyfile
end
