isoremix_root = @plugin.config["isoremix_root"]
bin_path = "/usr/local/bin"

deploy create: {
  in: isoremix_root,
  dirs: ["config", "clean", "rebuilt", "extra"]
}

deploy files: "rebuild-debian-iso",
  to: bin_path

deploy template: "preseed.cfg.erb",
  to: "#{isoremix_root}/preseed.cfg"

deploy template: "post_install.sh.erb",
  to: "#{isoremix_root}/extra/post_install.sh"

deploy template: "authorized_keys.erb",
  to: "#{isoremix_root}/extra/authorized_keys"

deploy package: ["bsdtar", "genisoimage"]

deploy do |machine|
  machine.chmod(file: "#{bin_path}/rebuild-debian-iso", permissions: "+x")

  machine.list_source_isos!
  machine.list_remix_configs!
  machine.list_rebuilt_isos!
end
