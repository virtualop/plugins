run do |params|
  @op.collect_contributions(
    "command_name" => "search_path",
    "raw_params" => params
  )
end
