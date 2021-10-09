description "adds a public key to the SSH directory of a user on a machine so that it is authorized to login"

param! :machine
param! "public_key", description: "the public key that should be added", :default_param => true

run do |machine, public_key|
  machine.mkdirs("dir" => ".ssh", "permissions" => "700")

  unless machine.file_exists(".ssh/authorized_keys")
    machine.ssh("touch .ssh/authorized_keys")
    machine.chmod("file" => ".ssh/authorized_keys", "permissions" => "600")
  end
  machine.append_to_file(file_name: ".ssh/authorized_keys", content: public_key)
end
