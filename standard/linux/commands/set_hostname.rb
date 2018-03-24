param! :machine
param! "new_name", default_param: true
param "new_domain", default: "local"

run do |machine, new_name, new_domain|
  full_name = "#{new_name}.#{new_domain}"

  machine.sudo "hostname #{full_name}"

  # update /etc/hosts
  # TODO or use machine.internal_ip instead ?
  # for hosts, it should be the external IP, probably?
  # TODO also, the default in Hetzner is external IP, so this does not work currently
  machine.replace_in_file(
    "file_name" => "/etc/hosts",
    "source" => "127\.0\.1\.1.*",
    "target" => "127.0.1.1 #{full_name} #{new_name}",
    "sudo" => true
  )

  # update /etc/hostname
  machine.write_file(
    "file_name" => "/etc/hostname",
    "content" => new_name,
    "sudo" => true
  )
end
