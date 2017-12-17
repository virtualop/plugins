param! :machine

run do |machine|
  machine.list_vms.map do |vm|
    vm["name"] =~ /^spare/ &&
    vm["state"] == "running" &&
    @op.test_ssh("machine" => "#{vm['name']}.#{machine.name}") ? vm["name"] : nil
  end.compact
end
