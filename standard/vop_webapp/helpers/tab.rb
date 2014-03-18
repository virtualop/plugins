def tab(name, title, path)
  #puts "registering tab #{name} for #{@plugin.name}"
  webapp = @op.plugin_by_name('vop_webapp')
  webapp.state[:tabs] ||= []
  webapp.state[:tabs] << { 
    'name' => name,
    'title' => title,
    'path' => path 
  }
end