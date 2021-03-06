param! :machine

param "vop_user", default: "marvin"

param "vop_domain"
param "cable_domain"

run do |machine, params, vop_user|
  # the vop needs a SSH key to connect to localhost
  machine.generate_keypair

  # vop config in /etc/vop should be writable
  config_dir = "/etc/vop"
  unless machine.file_exists config_dir
    machine.sudo "mkdir #{config_dir}"
    machine.sudo "chown #{vop_user}: #{config_dir}"
  end
  plugins_dir = "#{config_dir}/plugins.d"
  unless machine.file_exists plugins_dir
    machine.mkdirs plugins_dir
  end

  if params["vop_domain"]
    config_file = "/etc/vop/web.conf.sh"
    machine.write_file(file_name: config_file, content: "export VOP_DOMAIN=#{params["vop_domain"]}")
    if params["cable_domain"]
      machine.append_to_file(file_name: config_file, content: "export VOP_DOMAIN_CABLE=#{params["cable_domain"]}")
    end
    machine.chmod(file: config_file, permissions: "+x")

    machine.restart_systemd_service "vop-web"
  end
  true
end
