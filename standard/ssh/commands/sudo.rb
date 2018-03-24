param! :machine
param! "command", default_param: true

run do |machine, params|
  sudo_options = ""
  distro = machine.distro.split("_").first
  if %w|debian ubuntu|.include? distro
    sudo_options += "--non-interactive"
  end

  machine.ssh("command" => "sudo #{sudo_options} #{params["command"]}", "request_pty" => true)
end
