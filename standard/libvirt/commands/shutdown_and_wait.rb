param :machine
param :vm

on_machine do |machine, params|
  state = "unknown"
  # TODO snafu
  @op.without_cache do # to prevent situations where the vop has the wrong state
    state = machine.list_vms.select do |vm|
      vm["name"] == params["name"]
    end.first["state"]
  end
  
  if state == "running"
    # TODO maybe ask nicely first?
    machine.destroy_vm("name" => params["name"])
    
    @op.wait_until("interval" => 5, "timeout" => 30, 
      "error_text" => "could not find a machine with name '#{params["name"]}' that is shut off") do
      candidates = machine.list_vms.select do |row|
        row["name"] == params["name"] and
        row["state"] == "shut off"
      end
      candidates.size > 0
    end
  end

  'foo'
end
