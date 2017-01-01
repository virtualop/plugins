param! :machine

entity('name', on: 'machine') do |params|
  @op.collect_contributions('name' => 'working_copy', 'raw_params' => params)
end
