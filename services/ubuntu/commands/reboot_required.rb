param! :machine

run do |machine|
  machine.file_exists "/var/run/reboot-required"
end
