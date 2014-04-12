execute do |params|
  result = {
    'nodes' => [],
    'links' => []
  }
  
  all_plugins = @op.list_all_plugins.map do |row|
    @op.plugin_by_name(row['name'])
  end
  resolver = PluginDependencyResolver.new()
  ordered_plugins = resolver.order(all_plugins)
  
  groups = []
  ordered_plugins.each do |plugin|
    group_index = 0
    tags = plugin.tags
    if tags.size > 0
      first_tag = tags.first
      if groups.include? first_tag
        group_index = groups.index first_tag
      else
        groups << first_tag
        group_index = groups.size - 1
      end
    end
    
    result['nodes'] << {
      'name' => plugin.name,
      'group' => group_index
    }
    
    plugin.dependencies_status['met'].each do |dep_name|
      dep_index = result['nodes'].map { |x| x['name'] }.index(dep_name)
      
      if dep_index
        result['links'] << {
          'source' => result['nodes'].size - 1,
          'target' =>  dep_index,
          'value' => 1
        }
      else
        puts "unresolved #{dep_name} ?"
      end
    end
  end
  
  result.to_json()
end
