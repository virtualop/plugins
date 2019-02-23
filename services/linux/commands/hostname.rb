param! :machine

run do |machine|
  machine.ssh("hostname -f").strip
end
