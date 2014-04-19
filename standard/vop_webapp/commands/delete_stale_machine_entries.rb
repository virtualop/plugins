description "deletes machine entries for which there are no machines in list_machines anymore"

param 'sure', 'better be'

execute do
  machines = $op.list_machines
  
  morituri = Machine.all.select { |x| machines.select { |m| m["name"] == x["name"] }.size == 0 }
  
  if params['sure'] == 'yes'
    morituri.each do |m|
      m.delete()
    end
  end
  
  morituri      
end    