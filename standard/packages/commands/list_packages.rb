description "lists packages that are installed on this system"

param :machine

add_columns [ :name, :version ]

mark_as_read_only

with_contributions do |result, params|
  result
end

