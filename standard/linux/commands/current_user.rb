param! :machine

run do |machine|
  machine.ssh("whoami").strip
end
