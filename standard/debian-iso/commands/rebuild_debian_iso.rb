param! 'machine'
param! 'source'
param 'just_kidding'

run do |machine, plugin, source, just_kidding = false|
  puts "plugin : #{plugin.plugin_dir('files')}"

  # upload the script to rebuild
  machine.scp(
    "local_path" => plugin.plugin_dir('files') + "/rebuild-debian-iso",
    "remote_path" => "/tmp/rebuild-debian-iso"
  )

  # prepare preseed.cfg
  machine.ssh("ls /tmp/iso-rebuild || mkdir /tmp/iso-rebuild")
  # TODO might want to actually evaluate the template
  machine.scp(
    "local_path" => plugin.plugin_dir('templates') + "/preseed.cfg",
    "remote_path" => "/tmp/iso-rebuild/preseed.cfg"
  )

  # figure out names
  source_parts = source.split(".")
  source_parts.pop
  source_parts << "rebuilt"
  source_parts << "iso"
  target = source_parts.join(".")

  # run and grep the filename from the output
  rebuild_cmd = "/tmp/rebuild-debian-iso #{source} #{target} /tmp/iso-rebuild/preseed.cfg"
  if just_kidding
    puts "[noop] would run >>#{rebuild_cmd}<<"
  else
    output = machine.ssh("command" => rebuild_cmd, "user" => "root")
    matched = /Output ISO generated:\s+(.+)/m.match(output)
    matched.captures.first

    # TODO chown the resulting ISO?
  end
end
