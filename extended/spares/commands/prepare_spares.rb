param! :machine
param "count", description: "number of spares that should be available", default: 3

run do |machine, count|
  existing = machine.list_spares

  result = []
  1.upto(count.to_i) do |idx|
    vm_name = "spare#{sprintf('%02d', idx)}"

    unless existing.include? vm_name
      #NewVmWorker.perform_async(machine.name, vm_name)
      machine.new_vm_from_scratch("name" => vm_name)
      result << vm_name
    end
  end
  result
end
