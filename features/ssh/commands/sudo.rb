param! :machine
param! "command", default_param: true

param "show_output", default: false

run do |machine, params, show_output|
  sudo_options = ""
  distro = machine.distro.split("_").first
  if %w|debian ubuntu|.include? distro
    sudo_options += "--non-interactive"
  end

  machine.ssh(
    "command" => "sudo #{sudo_options} #{params["command"]}",
    "request_pty" => true,
    "show_output" => show_output
  )
end
