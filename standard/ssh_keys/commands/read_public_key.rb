param! :machine

run do |machine|
  machine.read_file ".ssh/id_rsa.pub"
end
