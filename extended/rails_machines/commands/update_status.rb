param! :machine
param "status_verb",
  description: "a verb that is used as prefix for -'ing' and -'ed' to build the current status (e.g. 'deploy' becomes 'deploying' and 'deployed')",
  default_param: true,
  default: "deploy"
param "from", description: "the first status", default: nil
param "to", description: "the status at the end", default: nil
block_param!

run do |machine, status_verb, params, block|
  # TODO something is wrong here with the block - when "from" and "to" are block params
  # (without detaults), "from" gets the block value
  from = params["from"]
  to = params["to"]
  unless status_verb || (from && to)
    raise "missing arguments: need either 'status_verb' or 'from' and 'to'"
  end
  if status_verb
    if from.nil?
      from = "#{status_verb}ing"
    end

    if to.nil?
      to = "#{status_verb}ed"
    end
  end


  installation = Installation.find_or_create_by(host_name: machine.parent.name, vm_name: machine.name.split(".").first)
  installation.status = from
  installation.save!

  block.call
  #yield

  installation.status = to
  installation.save!
end
