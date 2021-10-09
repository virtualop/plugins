description "generates a new key pair on the selected machine"

param! :machine
param "ssh_dir", "the ssh configuration directory (defaults to $HOME/.ssh)", default: ".ssh"
param "keyfile_name", default: "id_rsa"

run do |machine, ssh_dir, keyfile_name|
  private_keyfile = [ ssh_dir, keyfile_name ].join("/")
  public_keyfile = [ ssh_dir, keyfile_name, ".pub" ].join("/")
  unless machine.file_exists(private_keyfile)
    machine.mkdirs ssh_dir

    machine.ssh "ssh-keygen -N '' -f #{private_keyfile}"
    machine.list_files!(ssh_dir)

    machine.add_authorized_key(machine.read_public_key)
  end
end
