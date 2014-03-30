param :current_user

execute do |params|
  short_machine_names = @op.list_machines.pick(:name).map { |x| x.include?('.') ? x.split('.').first : x }
  short_machine_names.include? @op.dev_machine_name(params)
end
