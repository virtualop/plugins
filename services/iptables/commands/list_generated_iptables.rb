param! :machine

show columns: %w|name timestamp size|

run do |plugin, machine|
  machine.list_files(plugin.config["generator_path"])
end
