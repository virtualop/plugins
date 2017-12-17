param! "name"
param "path"
param "content"

require "fileutils"

run do |params|
  unless params["path"]
    # try to find a writable plugin directory
    first_non_usr = @op.plugin_locations.select { |location| not location.start_with? "/usr" }.first
    if first_non_usr.nil?
      raise "no writable plugin location found"
    else
      $logger.info "new_plugin defaulting to first writable plugin location #{first_non_usr}"
      params["path"] = first_non_usr
    end
  end

  raise "no such path: #{params["path"]}" unless File.exists? params["path"]

  pp params

  # a plugin is a directory
  plugin_path = File.join(params["path"], params["name"])
  puts "plugin path : #{plugin_path}"
  Dir.mkdir(plugin_path)

  # with subfolders for commands and helpers
  %w|commands helpers|.each do |thing|
    Dir.mkdir(File.join(plugin_path, thing))
  end

  # and a metadata file called "<name>.plugin"
  plugin_file = params["name"] + ".plugin"
  full_name = File.join(plugin_path, plugin_file)
  FileUtils.touch full_name

  # TODO content is [] - should probably be nil, though
  #puts "content: >>#{params["content"].pretty_inspect}<<"
  unless params["content"].nil?
    IO.write(full_name, params["content"])
  end

  $logger.info "created new plugin file #{plugin_file}"

  @op.reset
end
