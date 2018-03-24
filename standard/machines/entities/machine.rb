entity do |params|
  machines = @op.collect_contributions(
    command_name: "machines",
    raw_params: params
  )
  if machines
    machines.uniq! do |machine|
      machine["name"]
    end
  end
  machines
end
