param! :machine

run do |machine|
  machine.generate_iptables_script
  machine.run_iptables
end
