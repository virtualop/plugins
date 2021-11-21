# https://learn.hashicorp.com/vault/day-one/ops-deployment-guide
deploy url: "https://releases.hashicorp.com/vault/1.7.0/vault_1.7.0_linux_amd64.zip"

deploy do |machine, plugin|
  machine.install_package "unzip"
  machine.ssh "unzip vault_*_linux_amd64.zip"
  machine.sudo "chown root: vault"
  machine.sudo "mv vault /usr/local/bin/"
  version = machine.ssh "vault --version"
  puts "installed vault version #{version}"

  # TODO autocomplete support (works only once like this)
  # machine.ssh "vault -autocomplete-install"
  # machine.ssh "complete -C /usr/local/bin/vault vault"

  # Give Vault the ability to use the mlock syscall without running the process as root.
  # The mlock syscall prevents memory from being swapped to disk.
  machine.sudo "setcap cap_ipc_lock=+ep /usr/local/bin/vault"

  # Create a unique, non-privileged system user to run Vault.
  machine.add_system_user(name: "vault", homedir_path: "/etc/vault.d", shell: "/bin/false")

  # vault config
  machine.mkdirs "/etc/vault.d"
  machine.write_template(
    template: plugin.template_path(:config),
    to: "/etc/vault.d/vault.hcl"
  )
  machine.sudo "chown vault. /etc/vault.d/vault.hcl"

  # systemd config
  machine.write_template(
    template: plugin.template_path(:systemd),
    to: "/etc/systemd/system/vault.service"
  )
  machine.sudo "systemctl daemon-reload"
end
