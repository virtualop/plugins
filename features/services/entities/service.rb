on :machine

entity do |machine|
  @op.collect_contributions(
    command_name: "services",
    raw_params: { machine: machine }
  )
end
