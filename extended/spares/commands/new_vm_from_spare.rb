param! "name"

param! :machine, description: "a virtualization host on which the VM should be created"

run do |machine, name, params|
  spare = full_name = nil

  spares = machine.list_spares
  # TODO this should happen within a lock
  # TODO also, we should only use spares that have been installed completely
  if spares.size > 0
    spare = spares.first
    spare_full_name = "#{spare}.#{machine.name}"
    p = { :machine => spare_full_name, "new_name" => name }
    $logger.info "calling convert_spare : #{p.pretty_inspect}"
    full_name = @op.convert_spare(p)
  end

  if spare.nil?
    full_name = machine.new_vm_from_scratch(params)
  end

  full_name
end
