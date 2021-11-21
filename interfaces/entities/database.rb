on :machine

entity do |machine, params|
  machines = @op.collect_contributions(
    command_name: "databases",
    raw_params: params
  )
  machines
end
