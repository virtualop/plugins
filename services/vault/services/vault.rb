deploy repository: {
  alias: "hashicorp",
  url: "https://apt.releases.hashicorp.com",
  arch: "amd64",
  dist: "jammy",
  component: "main",
  key: "https://apt.releases.hashicorp.com/gpg"
}

deploy package: %w|vault|

deploy do |machine, plugin|
  version = machine.ssh "vault --version"
  puts "installed vault version #{version}"

  # vault config
  machine.mkdirs "/etc/vault.d"
  machine.write_template(
    template: plugin.template_path(:config),
    to: "/etc/vault.d/vault.hcl"
  )
  machine.sudo "chown vault. /etc/vault.d/vault.hcl"

  # home directory (user has been created already)
  machine.mkdirs "dir" => [ "/home/vault", "/home/vault/data" ]
  machine.sudo "chown -R vault. /home/vault"

  # systemd config
  machine.write_template(
    template: plugin.template_path(:systemd),
    to: "/etc/systemd/system/vault.service"
  )
  machine.sudo "systemctl daemon-reload"

  # systemd service
  machine.enable_systemd_service "vault"
  machine.start_systemd_service "vault"
end
