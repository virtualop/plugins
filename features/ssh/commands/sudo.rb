param! :machine
param! "command", default_param: true

param "user"
param "show_output", default: false

run do |machine, params, show_output, user|
  sudo_options = ""
  distro = machine.distro.split("_").first
  if %w|debian ubuntu|.include? distro
    sudo_options += "--non-interactive"
  end

  if user
    sudo_options += " -u #{user}"
  end

  machine.ssh(
    "command" => "sudo #{sudo_options} #{params["command"]}",
    "request_pty" => true,
    "show_output" => show_output
  )
end
