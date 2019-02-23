param! :machine
param! "source_iso", lookup: lambda { |params|
  @op.list_source_isos(params["machine"]).map { |x| x["name"] }
}

param "just_kidding", default: false

run do |machine, source_iso, just_kidding|
  config_dir = isoremix_dir("config")

  # prepare a directory to hold the config we've used
  unless source_iso =~ /(.+)\.iso$/
    raise "unexpected iso file extension"
  end
  base_name = $1
  config_root = File.join(config_dir, "#{base_name}.config")
  $logger.info "config base : #{config_root}"

  last_config = machine.list_remix_configs.select do |config|
    config["name"] =~ /^#{base_name}/
  end.map { |x| x["name"] }.sort.last

  idx = 1
  if last_config =~ /config(\d+)$/
    last_used_idx = $1.to_i
    idx = last_used_idx + 1
  end

  config_name = "#{config_root}#{idx}"
  $logger.info "storing config in #{config_name}"
  # TODO make sure there does not exist a dir named config_name yet
  machine.mkdirs(config_name)

  # copy the config we've used
  preseed_file = "/var/local/lib/isoremix/preseed.cfg"
  machine.sudo("cp #{preseed_file} #{config_name}/")
  preseed_file = "#{config_name}/preseed.cfg"

  extra_dir = "/var/local/lib/isoremix/extra"
  machine.sudo("cp -r #{extra_dir} #{config_name}/extra")
  extra_dir = "#{config_name}/extra"

  # figure out the name of the target ISO
  source_path = "/var/local/lib/isoremix/clean/#{source_iso}"
  target_path = "/var/local/lib/isoremix/rebuilt/#{base_name}.rebuild#{idx}.iso"

  # TODO potentially:
  # machine.rebuild_debian_iso_file(
  #   source: source_path,
  #   target: target_path,
  #   preseed_file: preseed_file,
  #   extra_dir: extra_dir
  # )

  # and go
  rebuild_cmd = "rebuild-debian-iso #{source_path} #{target_path} #{preseed_file} #{extra_dir}"

  if just_kidding
    puts "[noop] would run >>#{rebuild_cmd}<<"
  else
    output = machine.sudo(rebuild_cmd)
    $logger.info "output: #{output}"
    matched = /Output ISO generated:\s+(.+)/m.match(output)
    iso_path = matched.captures.first.strip

    machine.sudo "chown libvirt-qemu:kvm #{iso_path}"

    machine.list_rebuilt_isos!
    machine.list_remix_configs!
  end
end
