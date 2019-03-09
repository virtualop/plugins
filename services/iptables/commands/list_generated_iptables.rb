param! :machine

show columns: %w|name timestamp size|

run do |plugin, machine|
  machine.list_files(plugin.config["generator_path"]).select do |candidate|
    /#{plugin.config["script_name"]}/.match candidate["name"]
  end
end
