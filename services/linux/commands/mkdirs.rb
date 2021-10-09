param! :machine
param! "dir", multi: true, default_param: true
param "permissions"

run do |params, machine, permissions|
  params["dir"].each do |dir|
    command = "mkdir -p"
    if permissions
      command += " -m #{permissions}"
    end
    command += " #{dir}"

    unless machine.ssh_successful(command)
      # TODO better use machine.sudo?
      machine.ssh("sudo #{command}")
      machine.sudo("chown #{machine.current_user}. #{dir}")
    end
  end
end
