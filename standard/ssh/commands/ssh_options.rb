param! :machine

show :display_type => :hash

read_only

run do |params|
  @op.collect_contributions(
    "command_name" => "ssh_options",
    "raw_params" => params
  )
end
