description "returns the domains configured for a machine"

param :machine

add_columns [ :domain, :contributed_by ]

#mark_as_read_only

with_contributions do |result, params|
  result  
end
