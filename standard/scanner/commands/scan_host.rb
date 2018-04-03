param! :machine

run do |machine|
  machine.list_vms.each do |vm|
    @op.inspect_async "#{vm["name"]}.#{machine.name}"
  end
end
