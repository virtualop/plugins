param! 'machine'

run do |machine|
  machine.run_command("command_string" => "cat /etc/issue")
end
