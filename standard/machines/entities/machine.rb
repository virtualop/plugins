entity do |params|
  @op.collect_contributions(
    command_name: "machines",
    raw_params: params
  )
end
